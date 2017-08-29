I=imread('hangtian.jpg');
 I=rgb2gray(I);
 I1=I;
I=im2double(I);     %图像存储类型转换
T=dctmtx(8);       %离散余弦变换矩阵
B=blkproc(I,[8 8],'P1*x*P2',T,T');   %对原始图像进行余弦变换
%定义一个二值掩模矩阵，用来压缩DCT的系数，该矩阵只保留DCT变换矩阵的最左上角的10个系数
 mask=[1 1 1 1 0 0 0 0
         1 1 1 0 0 0 0 0
         1 1 0 0 0 0 0 0
         1 0 0 0 0 0 0 0
         0 0 0 0 0 0 0 0
         0 0 0 0 0 0 0 0
         0 0 0 0 0 0 0 0
         0 0 0 0 0 0 0 0];
% 数据压缩，丢弃右下角高频数据
B2=blkproc(B,[8 8],'P1.*x',mask);
I2=blkproc(B2,[8 8],'P1*x*P2',T',T);
% 进行DCT反变换，得到压缩后的图像
subplot(1,2,1),imshow(I1),title('原始图像');
subplot(1,2,2),imshow(I2),title('压缩后的图像');
