%����ͼ�񲢽���ת���ɻҶ�ͼ�� 
I=imread('tiantan.jpg');
I=rgb2gray(I);
% ���ɸ�˹�˲����ĺ� 
w=fspecial('gaussian',3,0.5);
size_a=size(I);

% ���и�˹�˲�
g=imfilter(I,w,'conv','symmetric','same');

% ������ 
t=g(1:2:size_a(1),1:2:size_a(2));

% ��ʾ������
imshow(I);
figure
imshow(t)