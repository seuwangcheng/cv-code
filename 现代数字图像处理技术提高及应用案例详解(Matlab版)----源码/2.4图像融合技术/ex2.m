% I1，I2 为两幅原始图像
% 对输入图像进行小波分解
y1=mywavedec2(I1,dim);
y2=mywavedec2(I2,dim);
% 根据低频融合算法进行图像融合
[r,c]=size(y1);           
% 首先取两幅源图像相应的小波分解系数绝对值最大者的值作为融合图像的分解系数

for i=1:r           
    for j=1:c
        if ( abs(y1(i,j)) >= abs(y2(i,j)) )
            y3(i,j)=y1(i,j);
        elseif ( abs(y1(i,j)) < abs(y2(i,j)) )
            y3(i,j)=y2(i,j);
        end
    end
end
