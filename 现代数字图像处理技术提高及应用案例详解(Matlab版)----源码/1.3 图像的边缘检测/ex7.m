% ����ͼ�񣬲�����ת���ɻҶ�ͼ��
I=imread('qipan.jpg');
I=rgb2gray(I);
% ��������
F=[-1 0 0 -1 -1
     1 1 1 0 0];
% ���о������
A=conv2(double(I),double(F));
% ת����8λ�޷������Ͳ���ʾ
A=uint8(A);
imshow(A)
