function G=gaussFilter(segma,kSize)
% 功能：实现高斯滤波
% 输入：
%     sigma-高斯分布的概率密度函数的方差
%     kSize-高斯向量的模板尺寸大小
% 输出：
%     G-方差为segma，大小为kSize的一维高斯向量模板

if nargin<1
    segma=1;
end
if nargin<2
    kSize=2*(segma*3);
end
 
x=-(kSize/2):(1+1/kSize):(kSize/2);
% 利用均值为0，方差为segma高斯分布概率密度函数求解一维高斯向量模板
G=(1/(sqrt(2*pi)*segma)) * exp (-(x.^2)/(2*segma^2));
