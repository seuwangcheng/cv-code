%����ͼ��,�����лҶ�ת��
A=imread('baihe.jpg');
B=rgb2gray(A);
%��ʼ����ֵ
T=0.5*(double(min(B(:)))+double(max(B(:))));
d=false;
%ͨ�������������ֵ
while~d
     g=B>=T;
     Tn=0.5*(mean(B(g))+mean(B(~g)));
     d=abs(T-Tn)<0.5;
     T=Tn;
end
% ���������ֵ����ͼ��ָ�
level=Tn/255;
BW=im2bw(B,level);
% ��ʾ�ָ���
subplot(121),imshow(A)
subplot(122),imshow(BW)
