function wi = color_compute_wi(pre_k_hist,cur_k_hist,cur_target_hist)

%   函数名和文件名	 :    color_compute_wi
%   版本号          ：   1.0
%   创建时间		：   2006.10.15
%   作者		      ：   pineapple
%   实现功能 		：   用先一帧的核直方图pre_k_hist，当前帧的枋直方图cur_k_hist和当前
%                       确良目标的直方图cur_target_hist
%   输入：
%       pre_k_hist      ：   先一帧的核直方图
%       cur_k_hist      ：   当前帧的枋直方图
%       cur_target_hist ：   当前目标的直方图
%
%   输出：
%       wi              ：   权系数
%
%   说明：
%	此算法的计算流程图参见"kernel-based object tracking".和compute_wi是一样的
[m,n] = size(cur_target_hist);
wi = zeros(m,n);
for i = 1 : m,
    for j = 1:n,
        wi(i,j)=(pre_k_hist(cur_target_hist(i,j))/cur_k_hist(cur_target_hist(i,j))).^0.5;
    end
end
end