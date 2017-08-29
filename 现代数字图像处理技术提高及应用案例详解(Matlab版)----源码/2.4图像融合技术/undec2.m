function Y = undec2(X)
% 功能：以步长2升采样
% 输入：X – 需要升采样的二维图像
% 输出：Y – 升采样后的图像
 [z s] = size(X);
Y     = zeros(2*z, 2*s); 
Y(1:2:2*z,1:2:2*s) = X;
