% ���ý�������
hgausspymd = video.Pyramid;
% �趨�������ֽ�Ĳ���Ϊ2
hgausspymd.PyramidLevel = 2;
% ����ͼ��
x = imread('qingdao.jpg');
% ִ�н������ֽ�
y = step(video.Pyramid, x);
% ��ʾ���
figure, imshow(x); title('ԭʼͼ��');
x1=mat2gray(double(y));
figure, imshow(x1);
title('Decomposed Image');