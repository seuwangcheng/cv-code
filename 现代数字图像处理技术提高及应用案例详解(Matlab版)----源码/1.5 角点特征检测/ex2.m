%%%%%%����ͼ����ʾ%%%%%%
I=imread('hua.jpg');
%��RGBͼ��ת���ɻҶ�ͼ��
I=rgb2gray(I);         
 subplot(1,3,1);
 imshow(I);
 title('����ͼ��');

%%%%%%���ɽǵ�������󲢽��е���%%%%%%
%���ɽǵ��������
C = cornermetric(I,'Harris');       
C_adjusted = imadjust(C);
subplot(1,3,2);
imshow(C_adjusted);
title('�ǵ����');

%%%%%%Ѱ�Ҳ���ʾHarris�ǵ�%%%%%%
corner_peaks = imregionalmax(C);
corner_idx = find(corner_peaks == true);
[r g b] = deal(I);
r(corner_idx) = 255;
g(corner_idx) = 255;
b(corner_idx) = 0;
RGB = cat(3,r,g,b);
subplot(1,3,3);
imshow(RGB);
title('������Harris�ǵ�');
