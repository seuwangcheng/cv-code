function [k_hist,target_hist,khist] = compute_k_hist(frame,target,kmatrix,MM)
%   函数和文件名    ：  color_compute_k_hist
%	版本           ：  1.0
%	创建时间       ：  2007.5.30
%   作者           ：  pineapple
%   实现功能       ：  计算彩色图像核直方图，和灰度图一样，只是级数=mm*mm*mm	              
%    输入：
%          frame : 当前帧
%          target     ：  选定的目标区域
%          kmatrix   ：  核矩阵
%          MM   : 量化级数
%    输出：
%         target_hist  ：  目标target的mm级直方图矩阵
%         k_hist       ：  目标target的核直方图
%         khist ： 分块后（四小块的各自的核直方图）
%	
%   注意：
%       为了和分块检测功能相符合，这里把目标分成四块分别计算其分布。
%   khist是一个结构体
%   **********************************************************************
%       
[m , n , k] = size(frame);
if(k==3)
    if nargin < 4
        mmr = 8;  mmg = 8;  mmb = 8; 
    end
    yyyy=mmr*mmg*mmb;
    khist.up = zeros(1,yyyy);       %上
    khist.right = zeros(1,yyyy);    %
    khist.left = zeros(1,yyyy);     %
    khist.down = zeros(1,yyyy);     %
    
    parts_k_hist = zeros(9,mmr*mmg*mmb);
    
    cpoint = target.cpoint;
    width  = target.width;

    k_hist = zeros(1,yyyy);
    target_image = frame(cpoint(1)-width(1):cpoint(1)+width(1),cpoint(2)-width(2):cpoint(2)+width(2),:); 
    [m,n,k] = size(target_image);
    target_hist = zeros(m,n);
    target_image = double(target_image);
    parts_index = [1 (m-1)/2   1    (n-1)/2; %左上 1
                   1 (m-1)/2 (n+3)/2      n; %右上 2 
                 (m+3)/2    m   (n+3)/2      n; %右下 3 
                (m+3)/2    m     1    (n-1)/2; %左下 4 
                (m+1)/2 (m+1)/2  1    (n-1)/2; % 中间行，左列 5
                (m+1)/2 (m+1)/2  (n+3)/2  n;   % 中间行，右列 6
                
                1 (m-1)/2   (n+1)/2  (n+1)/2 ; % 中间列，上行 7
                (m+3)/2  m  (n+1)/2  (n+1)/2 ; % 中间列，下行 8
                
                (m+1)/2 (m+1)/2  (n+1)/2  (n+1)/2] ; % 中间列，下行 9
for k = 1 : 9
    for i = parts_index(k,1) :parts_index(k,2)
        for j = parts_index(k,3) :parts_index(k,4)
            temp_1 = 1 + fix(target_image(i,j,1)*mmr/256);
            temp_2 = 1 + fix(target_image(i,j,2)*mmg/256);
            temp_3 = 1 + fix(target_image(i,j,3)*mmb/256);
            value = (temp_1-1)*mmg*mmb+(temp_2-1)*mmb+temp_3; 
            target_hist(i,j) = value;
            parts_k_hist(k,value) = parts_k_hist(k,value) + kmatrix(i,j);
            k_hist(1,value) = k_hist(1,value) + kmatrix(i,j);
        end
    end
end
    %   归一化
    k_hist = k_hist./(sum(k_hist)); 

    khist.rigth = parts_k_hist(2,:) + parts_k_hist(3,:) + parts_k_hist(7,:)+ parts_k_hist(8,:)+ parts_k_hist(9,:)+ parts_k_hist(6,:);
    khist.left =  parts_k_hist(1,:) + parts_k_hist(4,:) + parts_k_hist(7,:)+ parts_k_hist(8,:)+ parts_k_hist(9,:)+ parts_k_hist(5,:);
    khist.up =    parts_k_hist(1,:) + parts_k_hist(2,:) + parts_k_hist(5,:)+ parts_k_hist(6,:)+ parts_k_hist(9,:)+ parts_k_hist(7,:);
    khist.down =  parts_k_hist(3,:) + parts_k_hist(4,:) + parts_k_hist(5,:)+ parts_k_hist(6,:)+ parts_k_hist(9,:)+ parts_k_hist(8,:);
    
    khist.rigth = khist.rigth./(sum(khist.rigth));
    khist.left = khist.left./(sum(khist.left));
    khist.up = khist.up./(sum(khist.up));
    khist.down = khist.down./(sum(khist.down));
end

% cpoint = target.cpoint;
% width  = target.width;
%     k_hist1 = zeros(1,mmr*mmg*mmb);
%     target = frame(cpoint(1)-width(1):cpoint(1)+width(1),cpoint(2)-width(2):cpoint(2)+width(2),:); 
%     [m,n,k] = size(target);
%     target_hist1 = zeros(m,n);
%     target_image = double(target);
%     for i =1:m,
%         for j=1:n
%                 temp_1 = 1 + fix(target_image(i,j,1)*mmr/256);
%                 temp_2 = 1 + fix(target_image(i,j,2)*mmg/256);
%                 temp_3 = 1 + fix(target_image(i,j,3)*mmb/256);
%                 value = (temp_1-1)*mmg*mmb+(temp_2-1)*mmb+temp_3; 
%                 target_hist1(i,j) = value;
%                 k_hist1(1,value) = k_hist1(1,value) + kmatrix(i,j);
%             end
%     end
%     sum(k_hist1)
%     sum(kmatrix(:))
%     k_hist - k_hist1
%     target_hist1 - target_hist