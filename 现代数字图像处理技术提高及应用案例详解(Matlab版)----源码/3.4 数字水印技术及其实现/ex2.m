clear all
clc
clf
%定义一个新的avi文件
aviobj = avifile('withed11.avi','fps',15,'quality',85,'compression','RLE')
%产生高斯水印，并显示水印信息；
I=imread('Y.BMP');
I=double(I)/255; 
I=ceil(I);
mark0=I;
[rm,cm]=size(mark0);
subplot(2,3,1);imshow(mark0);title('原始水印图像'); 
alpha=0.5;
k1=randn(1,8);
k2=randn(1,8);
%显示原图
%mov1用来记录原始载体avi
%mov2用来记录水印载体avi
mov1 = aviread('lww.avi');
subplot(2,3,2);title('origine video');
movie(mov1)
fileinfo = aviinfo('lww.avi');
%嵌入水印
%p表示的是对视频中的每个帧进行操作
%p=0
for p=1:fileinfo.NumFrames
    %对每个帧进行水印嵌入
    %提取视频中的每一帧
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
    %下面的命令用来把水印嵌入的结果放入到movII的cdata中
   a1=blkproc(block_dct2,[8,8],'idct2');
   [x1,x2]=size(a1);
   movII.cdata=uint8(a1);
   [x3,x4]=size(movII.cdata);
    aviobj = addframe(aviobj,movII)
  end
aviobj = close(aviobj);
pause(4)
%用来调试的语句
%finishfileinfo = aviinfo('withwater8.avi')
fileinfo = aviinfo('withed11.avi');
pause(3);
movIII=aviread('withed11.avi',2)
[l1,l2]=size(movIII.cdata);
subplot(2,3,3);title('有水印的视频: ');
mov2 = aviread('withed11.avi');
movie(mov2)
