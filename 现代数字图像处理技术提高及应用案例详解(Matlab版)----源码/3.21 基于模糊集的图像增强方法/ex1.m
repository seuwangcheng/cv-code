x=imread('lena.bmp');
[M,N]=size(x);
x1=double(x);
% ��������
Fd=0.8;
FD=-1*Fd;
% Fe=128;
Fe=128;
Xmax=255;
% ģ������ƽ��
for i=1:M
    for j=1:N
        P(i,j)=(1+(Xmax-x1(i,j))/Fe)^FD;
    end
end
% ģ����ǿ
times=1;
for k=1:times
    for i=1:M
        for j=1:N
            if P(i,j) <= 0.5000
                P1(i,j)=2*P(i,j)^2;
            else
                P1(i,j)=1-2*(1-P(i,j))^2;
            end
        end
    end
    P=P1;
end
% ��ģ����
for i=1:M
    for j=1:N
        I(i,j)=Xmax-Fe*((1/P(i,j))^(1/Fd)-1);
    end
end
X=uint8(I);
figure,imshow(x);
figure,imshow(X);
