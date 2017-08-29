%读入图像
A=imread('hehua.jpg');
B=rgb2gray(A);
B=double(B);

%求图像的灰度直方图
hist(B)
[m,n]=size(B);
%根据直方图进行阈值分割
for i=1:m
    for j=1:n
%阈值
if B(i,j)>70&B(i,j)<130
            B(i,j)=1;
        else 
            B(i,j)=0;
        end
    end
end
%显示分割结果
subplot(121),imshow(A)
subplot(122),imshow(B)
