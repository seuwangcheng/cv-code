%读入图像,并进行灰度转换
A=imread('baihe.jpg');
B=rgb2gray(A);
%初始化阈值
T=0.5*(double(min(B(:)))+double(max(B(:))));
d=false;
%通过迭代求最佳阈值
while~d
     g=B>=T;
     Tn=0.5*(mean(B(g))+mean(B(~g)));
     d=abs(T-Tn)<0.5;
     T=Tn;
end
% 根据最佳阈值进行图像分割
level=Tn/255;
BW=im2bw(B,level);
% 显示分割结果
subplot(121),imshow(A)
subplot(122),imshow(BW)
