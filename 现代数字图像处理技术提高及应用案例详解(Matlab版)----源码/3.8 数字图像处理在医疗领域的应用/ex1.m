% 读取待处理的图像，将其转化为灰度图
I = imread('ranseti.bmp');
figure,imshow(I);
I2 = rgb2gray(I);
s = size(I2);
I4 = 255*ones(s(1), s(2), 'uint8');
I5 = imsubtract(I4,I2);
%对图像进行中值滤波去除噪声
I3 = medfilt2(I5,[5 5]);
%将图像转化为二值图像
I3 = imadjust(I3);
bw = im2bw(I3, 0.3);
%去除图像中面积过小的，可以肯定不是染色体的杂点
bw = bwareaopen(bw, 10);
figure,imshow(bw);
%标记连通的区域，以便统计染色体数量与面积
[labeled,numObjects] = bwlabel(bw,4);
%用颜色标记每一个染色体，以便直观显示
RGB_label=label2rgb(labeled,@spring,'c','shuffle');
figure,imshow(RGB_label);
%统计被标记的染色体区域的面积分布，显示染色体总数
chrdata = regionprops(labeled,'basic')
allchrs = [chrdata.Area];
num = size(allchrs)
nbins = 20;
figure,hist(allchrs,nbins);
title(num(2))
