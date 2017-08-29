function [cur_cpoint,cur_width,cur_k_hist,result] =...
color_object_tracking2(previous_frame,current_frame,pre_cpoint,pre_width)
%------------------------------------------------------------------------
%   函数和文件名   ：  color_object_tracking2
%   作者           ：  pineapple
%	版本           ：  2.0
%	创建时间       ：  2006.12.17
%   实现功能       ：  解决目标不断增大的情况。计算目标在新帧中的位置	              
%    输入：
%         previous_frame： 先前帧
%         current_frame ：   当前帧
%         pre_point     ：
%
%    输出：
%         cur_cpoint   ：  目标target的mm级直方图矩阵 类型为uint16
%         cur_width    ：  目标target的核直方图    类型为double
%         cur_k_hist   :   当前帧中找到的目标的核直方图，它可以用来更新目标模板
%
%   说明：
%       此程序的思想取自《mean-shift跟踪算法中核函数窗宽的自动选取》
%       专门来用解决目标逐渐变大的情况
v = -pre_width(1) : pre_width(1);
u = -pre_width(2) : pre_width(2);
V= repmat(v',1,2*pre_width(2)+1);    % [cow,colum]
U= repmat(u, 2*pre_width(1)+1,1);    % [cow,colum],'guass',sqrt(sum(pre_width.^2))
kmatrix = compute_kernelmatrix(pre_width);
[cur_k_hist,cur_target_hist] = color_compute_k_hist(previous_frame,cur_cpoint,cur_width,kmatrix);
cur_cpoint = pre_cpoint;  
cur_width  = pre_width;   
%   最多迭代10次
[cur_k_hist,cur_target_hist] = color_compute_k_hist(current_frame,cur_cpoint,cur_width,kmatrix);
result  = sum((pre_k_hist.*cur_k_hist).^(1/2));
fprintf('   第0次迭代得：%d,%d,%f\n',cur_cpoint(1),cur_cpoint(2),result);
for n_iter = 1 : 10;   
%   由核矩阵和目标区域的M级直方图，计算核直方图。它表征了目标的全部信息。
%    [cur_target_hist,cur_k_hist] = compute_k_hist(current_frame,cur_cpoint,cur_width,kmatrix);
%   由当前目标的直方图，当前目标的核直方图，上一帧中目标的核直方图，计算系数
    w = color_compute_wi(pre_k_hist,cur_k_hist,cur_target_hist);
 %   w = w.*kmatrix;
    temp_cur_cpoint(1)=sum(sum(w.*V))/sum(sum(w));
    temp_cur_cpoint(2)=sum(sum(w.*U))/sum(sum(w));
    temp_cur_cpoint(1) = round(temp_cur_cpoint(1));
    temp_cur_cpoint(2) = round(temp_cur_cpoint(2));
    cur_cpoint = cur_cpoint + temp_cur_cpoint;

    % 检测Bhattacharyya系数的大小  
   [cur_k_hist,cur_target_hist] = color_compute_k_hist(current_frame,cur_cpoint,cur_width,kmatrix);
   result1 = sum((pre_k_hist.*cur_k_hist).^(1/2)); 
   fprintf('   第%d次迭代得：%d,%d,%f\n', n_iter,cur_cpoint(1),cur_cpoint(2),result1);
   %    如果某一次迭代后得到的结果比迭代前还差，即系数变小了，则保留上一次的结果
 %  if(result1 < result)
  %    disp('warning for coefficient，save previous result!');
  %    cur_cpoint = cur_cpoint - temp_cur_cpoint;
  %    break;
  % end
   result = result1;
   if sum(temp_cur_cpoint.^2) == 0
        fprintf('      第%d次迭代成功\n', n_iter);
        break; 
    end
end
 %已经在当前帧中找到先前帧中的目标，下面是
%
