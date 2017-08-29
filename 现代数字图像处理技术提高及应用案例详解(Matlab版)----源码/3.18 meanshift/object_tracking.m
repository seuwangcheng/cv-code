function [newtarget,compute_info] =object_tracking(current_frame,target)
%------------------------------------------------------------------------
%   函数和文件名    ：  object_tracking
%   作者           ：  pineapple
%	版本           ：  1.0
%	创建时间       ：  2007.5.30
%   实现功能       ：  找到初始选定目标在当前帧中的最佳位置	              
%    输入：
%         pre_k_hist    :    先前帧中的目标核直方图
%         current_frame ：   当前帧
%         target
%    输出：
%       newtarget : 当前帧中的目标信息：位置，核直方图，分块核直方图，大小
%       compute_info ：在当前帧中，跟踪器的运算属性
%   说明：
%       1 本程序在colorexample中被调用。在第一帧选定目标之后，就一直用它的核直方
%         图做为跟踪的目标，在其它帧中搜索，中间不改变目标核直方图。
%       2 如果某一次迭代后得到的位置比先前位置的系数还要小，则中止迭代，保留上次
%         的结果
compute_info.coff = 0;
compute_info.iter = 0;
compute_info.dist = 0;
compute_info.position = target.cpoint;
current_cpoint = target.cpoint;
pre_k_hist = target.k_hist;
newtarget = target;

kmatrix = compute_kernelmatrix(target.width,'guass');% 由给定的大小，先算出核矩阵

v = -target.width(1) : target.width(1);
u = -target.width(2) : target.width(2);
V= repmat(v',1,2*target.width(2)+1);    % [cow,colum]
U= repmat(u, 2*target.width(1)+1,1);    % [cow,colum]

[cur_k_hist,cur_target_hist] = compute_k_hist(current_frame,target,kmatrix);
newtarget.k_hist = cur_k_hist;

result  = sum((pre_k_hist.*cur_k_hist).^(1/2));

% fprintf('   第0次迭代得：%d,%d,%f\n',target.cpoint(1),target.cpoint(2),result);
%   最多迭代10次
for n_iter = 1 : 10;
%   由当前目标的直方图，当前目标的核直方图，上一帧中目标的核直方图，计算系数
    w = compute_wi(pre_k_hist,cur_k_hist,cur_target_hist);
    %w = w.*kmatrix;
    temp_cur_cpoint(1)=sum(sum(w.*V))/sum(sum(w));
    temp_cur_cpoint(2)=sum(sum(w.*U))/sum(sum(w));
    temp_cur_cpoint(1) = round(temp_cur_cpoint(1));
    temp_cur_cpoint(2) = round(temp_cur_cpoint(2));
    target.cpoint = target.cpoint + temp_cur_cpoint;
    compute_info.position = [compute_info.position;target.cpoint];
 
    [cur_k_hist1,cur_target_hist,cur_four_khist1] = compute_k_hist(current_frame,target,kmatrix);
    result1 = sum((pre_k_hist.*cur_k_hist1).^(1/2));    % 检测Bhattacharyya系数的大小  
     fprintf('   第%d次迭代得：%d,%d,%f\n', n_iter,target.cpoint(1),target.cpoint(2),result1);
%  如果某一次迭代后得到的结果比迭代前还差，即系数变小了，则保留上一次的结果
    if(result1 < result)
       disp('warning for coefficient，save previous result!');
       target.cpoint = target.cpoint - temp_cur_cpoint;
       compute_info.position = [compute_info.position;target.cpoint];
       break;
    end
    result = result1;
    cur_k_hist = cur_k_hist1;
    cur_four_khist = cur_four_khist1;
    if sum(temp_cur_cpoint.^2) == 0
%         fprintf('      第%d次迭代成功\n', n_iter);
        break; 
    end
end
target.k_hist = cur_k_hist;
newtarget = target;
compute_info.coff = result;
compute_info.iter = n_iter;
compute_info.dist = sum(abs(target.cpoint - current_cpoint));