function [newtarget,compute_info] =object_tracking(current_frame,target)
%------------------------------------------------------------------------
%   �������ļ���    ��  object_tracking
%   ����           ��  pineapple
%	�汾           ��  1.0
%	����ʱ��       ��  2007.5.30
%   ʵ�ֹ���       ��  �ҵ���ʼѡ��Ŀ���ڵ�ǰ֡�е����λ��	              
%    ���룺
%         pre_k_hist    :    ��ǰ֡�е�Ŀ���ֱ��ͼ
%         current_frame ��   ��ǰ֡
%         target
%    �����
%       newtarget : ��ǰ֡�е�Ŀ����Ϣ��λ�ã���ֱ��ͼ���ֿ��ֱ��ͼ����С
%       compute_info ���ڵ�ǰ֡�У�����������������
%   ˵����
%       1 ��������colorexample�б����á��ڵ�һ֡ѡ��Ŀ��֮�󣬾�һֱ�����ĺ�ֱ��
%         ͼ��Ϊ���ٵ�Ŀ�꣬������֡���������м䲻�ı�Ŀ���ֱ��ͼ��
%       2 ���ĳһ�ε�����õ���λ�ñ���ǰλ�õ�ϵ����ҪС������ֹ�����������ϴ�
%         �Ľ��
compute_info.coff = 0;
compute_info.iter = 0;
compute_info.dist = 0;
compute_info.position = target.cpoint;
current_cpoint = target.cpoint;
pre_k_hist = target.k_hist;
newtarget = target;

kmatrix = compute_kernelmatrix(target.width,'guass');% �ɸ����Ĵ�С��������˾���

v = -target.width(1) : target.width(1);
u = -target.width(2) : target.width(2);
V= repmat(v',1,2*target.width(2)+1);    % [cow,colum]
U= repmat(u, 2*target.width(1)+1,1);    % [cow,colum]

[cur_k_hist,cur_target_hist] = compute_k_hist(current_frame,target,kmatrix);
newtarget.k_hist = cur_k_hist;

result  = sum((pre_k_hist.*cur_k_hist).^(1/2));

% fprintf('   ��0�ε����ã�%d,%d,%f\n',target.cpoint(1),target.cpoint(2),result);
%   ������10��
for n_iter = 1 : 10;
%   �ɵ�ǰĿ���ֱ��ͼ����ǰĿ��ĺ�ֱ��ͼ����һ֡��Ŀ��ĺ�ֱ��ͼ������ϵ��
    w = compute_wi(pre_k_hist,cur_k_hist,cur_target_hist);
    %w = w.*kmatrix;
    temp_cur_cpoint(1)=sum(sum(w.*V))/sum(sum(w));
    temp_cur_cpoint(2)=sum(sum(w.*U))/sum(sum(w));
    temp_cur_cpoint(1) = round(temp_cur_cpoint(1));
    temp_cur_cpoint(2) = round(temp_cur_cpoint(2));
    target.cpoint = target.cpoint + temp_cur_cpoint;
    compute_info.position = [compute_info.position;target.cpoint];
 
    [cur_k_hist1,cur_target_hist,cur_four_khist1] = compute_k_hist(current_frame,target,kmatrix);
    result1 = sum((pre_k_hist.*cur_k_hist1).^(1/2));    % ���Bhattacharyyaϵ���Ĵ�С  
     fprintf('   ��%d�ε����ã�%d,%d,%f\n', n_iter,target.cpoint(1),target.cpoint(2),result1);
%  ���ĳһ�ε�����õ��Ľ���ȵ���ǰ�����ϵ����С�ˣ�������һ�εĽ��
    if(result1 < result)
       disp('warning for coefficient��save previous result!');
       target.cpoint = target.cpoint - temp_cur_cpoint;
       compute_info.position = [compute_info.position;target.cpoint];
       break;
    end
    result = result1;
    cur_k_hist = cur_k_hist1;
    cur_four_khist = cur_four_khist1;
    if sum(temp_cur_cpoint.^2) == 0
%         fprintf('      ��%d�ε����ɹ�\n', n_iter);
        break; 
    end
end
target.k_hist = cur_k_hist;
newtarget = target;
compute_info.coff = result;
compute_info.iter = n_iter;
compute_info.dist = sum(abs(target.cpoint - current_cpoint));