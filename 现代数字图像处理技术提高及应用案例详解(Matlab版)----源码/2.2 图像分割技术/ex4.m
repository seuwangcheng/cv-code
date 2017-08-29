I=imread('shuixian.jpg');
Level=graythresh(I);
BW=im2bw(I,Level);
subplot(121),imshow(I);
subplot(122),imshow(BW);
