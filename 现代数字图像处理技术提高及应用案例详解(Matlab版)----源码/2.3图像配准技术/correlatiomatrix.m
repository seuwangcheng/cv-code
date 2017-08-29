function cormat = correlatiomatrix(im1, p1, im2, p2, w, dmax)
% 功能:计算相关矩阵
% 输入：im1-灰度图像im1(需要转换成double型)       im2-灰度图像im1(需要转换成double型)
%       p1-图像im1上的特征点（2×N矩阵）            p2-图像im2上的特征点（2×N矩阵）
%       w-窗口大小                                   damx-最大匹配半径
% 输出：cormat-相关矩阵
if mod(w, 2) == 0
    error('Window size should be odd');
end
[rows1, npts1] = size(p1);
[rows2, npts2] = size(p2);   
cormat = -ones(npts1,npts2)*Inf;
if rows1 ~= 2 | rows2 ~= 2
    error('Feature points must be specified in 2xN arrays');
end
[im1rows, im1cols] = size(im1);
[im2rows, im2cols] = size(im2);   
% 相关运算窗口半径 
r = (w-1)/2;  
n1ind = find(p1(1,:)>r & p1(1,:)<im1rows+1-r &  p1(2,:)>r & p1(2,:)<im1cols+1-r);
n2ind = find(p2(1,:)>r & p2(1,:)<im2rows+1-r &  p2(2,:)>r & p2(2,:)<im2cols+1-r); 
for n1 = n1ind           
    w1 = im1(p1(1,n1)-r:p1(1,n1)+r, p1(2,n1)-r:p1(2,n1)+r);
    w1 = w1./sqrt(sum(sum(w1.*w1)));
    if dmax == inf
    n2indmod = n2ind; 
    else     
    p1pad = repmat(p1(:,n1),1,length(n2ind));
    dists2 = sum((p1pad-p2(:,n2ind)).^2);
    n2indmod = n2ind(find(dists2 < dmax^2));
 end
    for n2 = n2indmod
        w2 = im2(p2(1,n2)-r:p2(1,n2)+r, p2(2,n2)-r:p2(2,n2)+r);
        cormat(n1,n2) = sum(sum(w1.*w2))/sqrt(sum(sum(w2.*w2)));
    end 
end
