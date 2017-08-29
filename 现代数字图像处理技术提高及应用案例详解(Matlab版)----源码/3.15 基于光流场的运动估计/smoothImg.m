function smoothedImg=smoothImg(img,segma)
% 功能：实现平滑性约束条件
% 输入：
%     img-数字图像
%     sigma-高斯分布的方差
% 输出：
%     smoothedImg-经高斯滤波的图像矩阵

if nargin<2
    segma=1;
end
%调用高斯滤波函数
G=gaussFilter(segma);  
%根据（3.15.7）对图像进行平滑约束
smoothedImg=conv2(img,G,'same');  
% 二次平滑
smoothedImg=conv2(smoothedImg,G','same');  
