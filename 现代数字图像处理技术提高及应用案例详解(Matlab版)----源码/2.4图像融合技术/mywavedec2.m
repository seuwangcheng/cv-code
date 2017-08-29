function y=mywavedec2(x,dim)
% 函数 MYWAVEDEC2() 对输入矩阵 x 进行 dim 层分解，得到相应的分解系数矩阵 y
% 输入参数：x —— 输入矩阵；	
%           dim —— 分解层数。
% 输出参数：y —— 分解系数矩阵。
x=modmat(x,dim);            % 首先规范化输入矩阵，使其行列数均能被 2^dim 整除
subplot(121);imshow(x);title('原始图像');   % 画出规范化后的源图像
[m,n]=size(x);              % 求出规范化矩阵x的行列数
xd=double(x);               % 将矩阵x的数据格式转换为适合数值处理的double格式
for i=1:dim
    xd=modmat(xd,1);
    [dLL,dHL,dLH,dHH]=mydwt2(xd);   % 矩阵小波分解
    tmp=[dLL,dHL;dLH,dHH];          % 将分解系数存入缓存矩阵
    xd=dLL;                         % 将缓存矩阵左上角部分的子矩阵作为下一层分解的源矩阵
    [row,col]=size(tmp);            % 求出缓存矩阵的行列数
    y(1:row,1:col)=tmp;             % 将缓存矩阵存入输出矩阵的相应行列
end
yd=uint8(y);            % 将输出矩阵的数据格式转换为适合显示图像的uint8格式
for i=1:dim             % 对矩阵 yd 进行分界线处理，画出分解图像的分界线
    m=m-mod(m,2);
    n=n-mod(n,2);
    yd(m/2,1:n)=255;
    yd(1:m,n/2)=255;
    m=m/2;n=n/2;
end
subplot(122);imshow(yd);title([ num2str(dim) ' 层小波分解图像']); 
