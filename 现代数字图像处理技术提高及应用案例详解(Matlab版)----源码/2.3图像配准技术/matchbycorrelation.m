function[m1,m2,cormat] = matchbycorrelation(im1, p1, im2, p2, w, dmax)
% 功能:基于特征点的图像配准
% 输入：im1-灰度图像im1(需要转换成double型)        im2-灰度图像im1(需要转换成double型)
%       p1-图像im1上的特征点（2×N矩阵）             p2-图像im2上的特征点（2×N矩阵）
%       w-窗口大小                                    damx-最大匹配半径
% 输出：m1-灰度图像im1中匹配点的坐标                 m2-灰度图像im1中匹配点的坐标
%       cormat-相关矩阵
if nargin == 5
    dmax = Inf;
end
im1 = double(im1);
im2 = double(im2);
im1 = im1 - filter2(fspecial('average',w),im1);
im2 = im2 - filter2(fspecial('average',w),im2);   
% 产生相关矩阵
cormat = correlatiomatrix(im1, p1, im2, p2, w, dmax);
[corrows,corcols] = size(cormat);
% 查找相关矩阵中的最大值
[mp2forp1, colp2forp1] = max(cormat,[],2);
[mp1forp2, rowp1forp2] = max(cormat,[],1);   
p1ind = zeros(1,length(p1)); 
p2ind = zeros(1,length(p2));   
indcount = 0;   
for n = 1:corrows
    if rowp1forp2(colp2forp1(n)) == n  
        indcount = indcount + 1;
        p1ind(indcount) = n;
        p2ind(indcount) = colp2forp1(n);
    end
end
% 整理匹配点坐标
p1ind = p1ind(1:indcount);   
p2ind = p2ind(1:indcount);       
% 从原始矩阵中提取匹配点坐标
m1 = p1(:,p1ind); 
m2 = p2(:,p2ind); 
