X=imread('robot.jpg');
X=rgb2gray(X);
X1=X;
% �ֽ�ͼ����ȡ�ֽ�ṹ�еĵ�һ��ϵ��
[c,l]=wavedec2(X,2,'bior3.7');
cA1=appcoef2(c,l,'bior3.7',1);
cH1=detcoef2('h',c,l,1);
cD1=detcoef2('d',c,l,1);
cV1=detcoef2('v',c,l,1);
% �ع���һ��ϵ��
A1=wrcoef2('a',c,l,'bior3.7',1);
H1=wrcoef2('h',c,l,'bior3.7',1);
D1=wrcoef2('d',c,l,'bior3.7',1);
V1=wrcoef2('v',c,l,'bior3.7',1);
c1=[A1 H1;V1 D1];
subplot(221),imshow(X1),title('ԭʼͼ��'); axis square;
subplot(222),image(c1);title('�ֽ��ĸ�Ƶ�͵�Ƶ��Ϣ');
axis square
% ��ͼ�����ѹ����������һ���Ƶ��Ϣ�����������������
ca1=wcodemat(cA1,440,'mat',0);
ca1=0.5*ca1;
subplot(223);image(ca1);
axis square;
title('��һ��ѹ��ͼ��Ĵ�С:');
% ѹ��ͼ�񣬱����ڶ����Ƶ��Ϣ�����������������
cA2=appcoef2(c,l,'bior3.7',2);
ca2=wcodemat(cA2,440,'mat',0);
ca2=0.5*ca2;
subplot(224);
image(ca2);
title('�ڶ���ѹ��ͼ��');
axis square;
