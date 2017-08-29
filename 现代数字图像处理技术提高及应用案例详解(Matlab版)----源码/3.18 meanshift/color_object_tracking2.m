function [cur_cpoint,cur_width,cur_k_hist,result] =...
color_object_tracking2(previous_frame,current_frame,pre_cpoint,pre_width)
%------------------------------------------------------------------------
%   �������ļ���   ��  color_object_tracking2
%   ����           ��  pineapple
%	�汾           ��  2.0
%	����ʱ��       ��  2006.12.17
%   ʵ�ֹ���       ��  ���Ŀ�겻����������������Ŀ������֡�е�λ��	              
%    ���룺
%         previous_frame�� ��ǰ֡
%         current_frame ��   ��ǰ֡
%         pre_point     ��
%
%    �����
%         cur_cpoint   ��  Ŀ��target��mm��ֱ��ͼ���� ����Ϊuint16
%         cur_width    ��  Ŀ��target�ĺ�ֱ��ͼ    ����Ϊdouble
%         cur_k_hist   :   ��ǰ֡���ҵ���Ŀ��ĺ�ֱ��ͼ����������������Ŀ��ģ��
%
%   ˵����
%       �˳����˼��ȡ�ԡ�mean-shift�����㷨�к˺���������Զ�ѡȡ��
%       ר�����ý��Ŀ���𽥱������
v = -pre_width(1) : pre_width(1);
u = -pre_width(2) : pre_width(2);
V= repmat(v',1,2*pre_width(2)+1);    % [cow,colum]
U= repmat(u, 2*pre_width(1)+1,1);    % [cow,colum],'guass',sqrt(sum(pre_width.^2))
kmatrix = compute_kernelmatrix(pre_width);
[cur_k_hist,cur_target_hist] = color_compute_k_hist(previous_frame,cur_cpoint,cur_width,kmatrix);
cur_cpoint = pre_cpoint;  
cur_width  = pre_width;   
%   ������10��
[cur_k_hist,cur_target_hist] = color_compute_k_hist(current_frame,cur_cpoint,cur_width,kmatrix);
result  = sum((pre_k_hist.*cur_k_hist).^(1/2));
fprintf('   ��0�ε����ã�%d,%d,%f\n',cur_cpoint(1),cur_cpoint(2),result);
for n_iter = 1 : 10;   
%   �ɺ˾����Ŀ�������M��ֱ��ͼ�������ֱ��ͼ����������Ŀ���ȫ����Ϣ��
%    [cur_target_hist,cur_k_hist] = compute_k_hist(current_frame,cur_cpoint,cur_width,kmatrix);
%   �ɵ�ǰĿ���ֱ��ͼ����ǰĿ��ĺ�ֱ��ͼ����һ֡��Ŀ��ĺ�ֱ��ͼ������ϵ��
    w = color_compute_wi(pre_k_hist,cur_k_hist,cur_target_hist);
 %   w = w.*kmatrix;
    temp_cur_cpoint(1)=sum(sum(w.*V))/sum(sum(w));
    temp_cur_cpoint(2)=sum(sum(w.*U))/sum(sum(w));
    temp_cur_cpoint(1) = round(temp_cur_cpoint(1));
    temp_cur_cpoint(2) = round(temp_cur_cpoint(2));
    cur_cpoint = cur_cpoint + temp_cur_cpoint;

    % ���Bhattacharyyaϵ���Ĵ�С  
   [cur_k_hist,cur_target_hist] = color_compute_k_hist(current_frame,cur_cpoint,cur_width,kmatrix);
   result1 = sum((pre_k_hist.*cur_k_hist).^(1/2)); 
   fprintf('   ��%d�ε����ã�%d,%d,%f\n', n_iter,cur_cpoint(1),cur_cpoint(2),result1);
   %    ���ĳһ�ε�����õ��Ľ���ȵ���ǰ�����ϵ����С�ˣ�������һ�εĽ��
 %  if(result1 < result)
  %    disp('warning for coefficient��save previous result!');
  %    cur_cpoint = cur_cpoint - temp_cur_cpoint;
  %    break;
  % end
   result = result1;
   if sum(temp_cur_cpoint.^2) == 0
        fprintf('      ��%d�ε����ɹ�\n', n_iter);
        break; 
    end
end
 %�Ѿ��ڵ�ǰ֡���ҵ���ǰ֡�е�Ŀ�꣬������
%
