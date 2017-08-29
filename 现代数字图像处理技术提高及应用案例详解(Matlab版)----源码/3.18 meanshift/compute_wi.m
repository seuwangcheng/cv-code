function wi = color_compute_wi(pre_k_hist,cur_k_hist,cur_target_hist)

%   ���������ļ���	 :    color_compute_wi
%   �汾��          ��   1.0
%   ����ʱ��		��   2006.10.15
%   ����		      ��   pineapple
%   ʵ�ֹ��� 		��   ����һ֡�ĺ�ֱ��ͼpre_k_hist����ǰ֡����ֱ��ͼcur_k_hist�͵�ǰ
%                       ȷ��Ŀ���ֱ��ͼcur_target_hist
%   ���룺
%       pre_k_hist      ��   ��һ֡�ĺ�ֱ��ͼ
%       cur_k_hist      ��   ��ǰ֡����ֱ��ͼ
%       cur_target_hist ��   ��ǰĿ���ֱ��ͼ
%
%   �����
%       wi              ��   Ȩϵ��
%
%   ˵����
%	���㷨�ļ�������ͼ�μ�"kernel-based object tracking".��compute_wi��һ����
[m,n] = size(cur_target_hist);
wi = zeros(m,n);
for i = 1 : m,
    for j = 1:n,
        wi(i,j)=(pre_k_hist(cur_target_hist(i,j))/cur_k_hist(cur_target_hist(i,j))).^0.5;
    end
end
end