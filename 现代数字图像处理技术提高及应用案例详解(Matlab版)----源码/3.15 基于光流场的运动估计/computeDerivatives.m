function [fx, fy, ft] = computeDerivatives(im1, im2)

% 功能：求输入图像参考像素点的像素值沿三轴方向的偏导数
% 输入：
%     im1-输入图像1
%     im2-输入图像2
% 输出：
%     fx-参考像素点的灰度值沿x方向的偏导数
%     fy-参考像素点的灰度值沿y方向的偏导数
%     fz-参考像素点的灰度值沿z方向的偏导数

if size(im2,1)==0
    im2=zeros(size(im1));
end
 
% 利用标准模板求得式（3.15.5）中的偏导数Ix, Iy, It
fx = conv2(im1,0.25* [-1 1; -1 1],'same') + conv2(im2, 0.25*[-1 1; -1 1],'same');
fy = conv2(im1, 0.25*[-1 -1; 1 1], 'same') + conv2(im2, 0.25*[-1 -1; 1 1], 'same');
ft = conv2(im1, 0.25*ones(2),'same') + conv2(im2, -0.25*ones(2),'same');
