%����ͼ��
A=imread('hehua.jpg');
B=rgb2gray(A);
B=double(B);

%��ͼ��ĻҶ�ֱ��ͼ
hist(B)
[m,n]=size(B);
%����ֱ��ͼ������ֵ�ָ�
for i=1:m
    for j=1:n
%��ֵ
if B(i,j)>70&B(i,j)<130
            B(i,j)=1;
        else 
            B(i,j)=0;
        end
    end
end
%��ʾ�ָ���
subplot(121),imshow(A)
subplot(122),imshow(B)
