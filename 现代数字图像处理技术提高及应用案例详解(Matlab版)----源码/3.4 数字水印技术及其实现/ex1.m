clear all; 
clc;
start_time=cputime;
%%%%%% ��ȡˮӡͼ�� %%%%%%
I=imread('mark.bmp');
I=rgb2gray(I);
I=double(I)/255; 
I=ceil(I);
%%%%%%��ʾˮӡͼ��%%%%%%
figure(1);
subplot(2,3,1);
imshow(I),title('ˮӡͼ��')
dimI=size(I);
rm=dimI(1);cm=dimI(2);
%%%%%%��������ˮӡ��Ϣ %%%%%%
mark=I;
alpha=50,
k1=randn(1,8);
k2=randn(1,8);
a0=imread('lena.bmp');
psnr_cover=double(a0);
subplot(2,3,2),imshow(a0,[]),title('����ͼ��');
[r,c]=size(a0);
cda0=blkproc(a0,[8,8],'dct2');
%%%%%% Ƕ�� %%%%%%
cda1=cda0;   % cda1 = 256_256
for i=1:32  % i=1:32
    for j=1:32  % j=1:32
        x=(i-1)*8;y=(j-1)*8;
        if mark(i,j)==1
        k=k1;
        else
        k=k2; 
        end
    cda1(x+1,y+8)=cda0(x+1,y+8)+alpha*k(1);
    cda1(x+2,y+7)=cda0(x+2,y+7)+alpha*k(2);
    cda1(x+3,y+6)=cda0(x+3,y+6)+alpha*k(3);
    cda1(x+4,y+5)=cda0(x+4,y+5)+alpha*k(4);
    cda1(x+5,y+4)=cda0(x+5,y+4)+alpha*k(5);
    cda1(x+6,y+3)=cda0(x+6,y+3)+alpha*k(6);
    cda1(x+7,y+2)=cda0(x+7,y+2)+alpha*k(7);
    cda1(x+8,y+1)=cda0(x+8,y+1)+alpha*k(8);
   
    end
end
%%%%%%Ƕ��ˮӡ��ͼ�� %%%%%%
a1=blkproc(cda1,[8,8],'idct2'); 
a_1=uint8(a1);
imwrite(a_1,'withmark.bmp','bmp');
subplot(2,3,3),imshow(a1,[]),title('Ƕ��ˮӡ���ͼ��');
disp('Ƕ��ˮӡ����ʱ��');
embed_time=cputime-start_time,
%%%%%% ����ʵ�� ����³���� %%%%%%%
disp('��Ƕ��ˮӡ��ͼ��Ĺ���ʵ�飬������ѡ���');
disp('1--��Ӱ�����');
disp('2--��˹��ͨ�˲�');
disp('3--JPEG ѹ��');
disp('4--ͼ�����');
disp('5--��ת10��');
disp('6--ֱ�Ӽ��ˮӡ');
disp('����--������');
d=input('������ѡ��1-6��:');
start_time=cputime;
    figure(1);
            switch d
                case 6
            subplot(2,3,4);
            imshow(a1,[]);
            title('δ�ܹ����ĺ�ˮӡͼ��');
            M1=a1;                      
                case 1
             WImage2=a1;
             noise0=20*randn(size(WImage2));
             WImage2=WImage2+noise0;
             subplot(2,3,4);
             imshow(WImage2,[]);
             title('�����������ͼ��');
             M1=WImage2;
             M_1=uint8(M1);
             imwrite(M_1,'whitenoise.bmp','bmp');
                case 2
             WImage3=a1;
             H=fspecial('gaussian',[4,4],0.2);
             WImage3=imfilter(WImage3,H);
             subplot(2,3,4);
             imshow(WImage3,[]);
             title('��˹��ͨ�˲���ͼ��');
             M1=WImage3;
             M_1=uint8(M1);
             imwrite(M_1,'gaussian.bmp','bmp');
                case 4
             WImage4=a1;
             WImage4(1:64,1:512)=512;
             %WImage4(224:256,1:256)=256;
             %WImage4(1:256,224:256)=256;
             %WImage4(1:256,1:32)=256;
             WImage4cl=mat2gray(WImage4);
             figure(2);
             subplot(1,1,1);
             %subplot(2,3,4);
             imshow(WImage4cl);
             title('���ּ��к�ͼ��');
             figure(1);
             M1=WImage4cl;
             %M_1=uint8(M1);
             %imwrite(M_1,'cutpart.bmp','bmp');
                case 3
             WImage5=a1;
             WImage5=im2double(WImage5);
             cnum=10;
             dctm=dctmtx(8);
             P1=dctm;
             P2=dctm.';
             imageDCT=blkproc(WImage5,[8,8],'P1*x*P2',dctm,dctm.');
             DCTvar=im2col(imageDCT,[8,8],'distinct').';
             n=size(DCTvar,1);
             DCTvar=(sum(DCTvar.*DCTvar)-(sum(DCTvar)/n).^2)/n;
             [dum,order]=sort(DCTvar);
             cnum=64-cnum;
             mask=ones(8,8);
             mask(order(1:cnum))=zeros(1,cnum);
             im88=zeros(9,9);
             im88(1:8,1:8)=mask;
             im128128=kron(im88(1:8,1:8),ones(16));
             dctm=dctmtx(8);
             P1=dctm.';
             P2=mask(1:8,1:8);
             P3=dctm;
WImage5=blkproc(imageDCT,[8,8],'P1*(x.*P2)*P3',dctm.',mask(1:8,1:8),dctm);
             WImage5cl=mat2gray(WImage5);
             subplot(2,3,4);
             imshow(WImage5cl);
             title('��JPEGѹ����ͼ��');
             %figure(1);
             M1=WImage5cl;
                case 5
            WImage6=a1;
            WImage6=imrotate(WImage6,10,'bilinear','crop');
            WImage6cl=mat2gray(WImage6);
            figure(2);
            subplot(1,1,1);
            imshow(WImage6cl);
            title('��ת10�Ⱥ�ͼ��');  
            figure(1);
            M1=WImage6cl;
                  otherwise
            disp('�����������Ч���֣�ͼ��δ�ܹ�������ֱ�Ӽ��ˮӡ');
            subplot(2,3,4);
            imshow(a1,[]);
            title('δ�ܹ����ĺ�ˮӡͼ��');
            M1=a1;
                end

