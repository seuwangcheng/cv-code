function Y = dec2(X);
% 功能： 以步长2降采样
% 输入： X – 输入的灰度图像
% 输出： Y – 采样后的图像
[a b] = size(X);
Y     = X(1:2:a, 1:2:b);
