clear all
clc
clf
%����һ���µ�avi�ļ�
aviobj = avifile('withed11.avi','fps',15,'quality',85,'compression','RLE')
%������˹ˮӡ������ʾˮӡ��Ϣ��
I=imread('Y.BMP');
I=double(I)/255; 
I=ceil(I);
mark0=I;
[rm,cm]=size(mark0);
subplot(2,3,1);imshow(mark0);title('ԭʼˮӡͼ��'); 
alpha=0.5;
k1=randn(1,8);
k2=randn(1,8);
%��ʾԭͼ
%mov1������¼ԭʼ����avi
%mov2������¼ˮӡ����avi
mov1 = aviread('lww.avi');
subplot(2,3,2);title('origine video');
movie(mov1)
fileinfo = aviinfo('lww.avi');
%Ƕ��ˮӡ
%p��ʾ���Ƕ���Ƶ�е�ÿ��֡���в���
%p=0
for p=1:fileinfo.NumFrames
    %��ÿ��֡����ˮӡǶ��
    %��ȡ��Ƶ�е�ÿһ֡
    movI=aviread('lww.avi',p);
    movII=aviread('lww.avi',p);
    [l1,l2]=size(movI.cdata);
        block_dct1=blkproc(movI.cdata,[8,8],'dct2');
    block_dct2=block_dct1;
    for i=1:rm
        for j=1:cm
            x=(i-1)*8;y=(j-1)*8;
            if mark0(i,j)==1
                k=k1;
            else
                k=k2;
            end
    block_dct2(x+1,y+8)=block_dct1(x+1,y+8)+alpha*k(1);
    block_dct2(x+2,y+7)=block_dct1(x+2,y+7)+alpha*k(2);
    block_dct2(x+3,y+6)=block_dct1(x+3,y+6)+alpha*k(3);
    block_dct2(x+4,y+5)=block_dct1(x+4,y+5)+alpha*k(4);
    block_dct2(x+5,y+4)=block_dct1(x+5,y+4)+alpha*k(5);
    block_dct2(x+6,y+3)=block_dct1(x+6,y+3)+alpha*k(6);
    block_dct2(x+7,y+2)=block_dct1(x+7,y+2)+alpha*k(7);
    block_dct2(x+8,y+1)=block_dct1(x+8,y+1)+alpha*k(8);
    end
end
    %���������������ˮӡǶ��Ľ�����뵽movII��cdata��
   a1=blkproc(block_dct2,[8,8],'idct2');
   [x1,x2]=size(a1);
   movII.cdata=uint8(a1);
   [x3,x4]=size(movII.cdata);
    aviobj = addframe(aviobj,movII)
  end
aviobj = close(aviobj);
pause(4)
%�������Ե����
%finishfileinfo = aviinfo('withwater8.avi')
fileinfo = aviinfo('withed11.avi');
pause(3);
movIII=aviread('withed11.avi',2)
[l1,l2]=size(movIII.cdata);
subplot(2,3,3);title('��ˮӡ����Ƶ: ');
mov2 = aviread('withed11.avi');
movie(mov2)
