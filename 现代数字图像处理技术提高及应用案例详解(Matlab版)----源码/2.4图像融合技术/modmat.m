function y=modmat(x,dim)
% 函数 MODMAT() 对输入矩阵x进行规范化，使其行列数均能被 2^dim 整除
% 输入参数：x —— r*c 维矩阵；
%           dim —— 矩阵重构的维数
% 输出参数：y —— rt*ct 维矩阵，mod(rt,2^dim)=0，mod(ct,2^dim)=0
[row,col]=size(x);          % 求出输入矩阵的行列数row,col
rt=row - mod(row,2^dim);    % 将row,col分别减去本身模 2^dim 得到的数
ct=col - mod(col,2^dim);    % 所得的差为rt、ct，均能被 2^dim 整除
y=x(1:rt,1:ct);             % 输出矩阵 y 为输入矩阵 x 的 rt*ct 维子矩阵 
