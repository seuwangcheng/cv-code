X=imread('robot.jpg');
X=rgb2gray(X);
X1=X;
% 分解图像，提取分解结构中的第一层系数
[c,l]=wavedec2(X,2,'bior3.7');
cA1=appcoef2(c,l,'bior3.7',1);
cH1=detcoef2('h',c,l,1);
cD1=detcoef2('d',c,l,1);
cV1=detcoef2('v',c,l,1);
% 重构第一层系数
A1=wrcoef2('a',c,l,'bior3.7',1);
H1=wrcoef2('h',c,l,'bior3.7',1);
D1=wrcoef2('d',c,l,'bior3.7',1);
V1=wrcoef2('v',c,l,'bior3.7',1);
c1=[A1 H1;V1 D1];
subplot(221),imshow(X1),title('原始图像'); axis square;
subplot(222),image(c1);title('分解后的高频和低频信息');
axis square
% 对图像进行压缩，保留第一层低频信息并对其进行量化编码
ca1=wcodemat(cA1,440,'mat',0);
ca1=0.5*ca1;
subplot(223);image(ca1);
axis square;
title('第一次压缩图像的大小:');
% 压缩图像，保留第二层低频信息并对其进行量化编码
cA2=appcoef2(c,l,'bior3.7',2);
ca2=wcodemat(cA2,440,'mat',0);
ca2=0.5*ca2;
subplot(224);
image(ca2);
title('第二次压缩图像');
axis square;
