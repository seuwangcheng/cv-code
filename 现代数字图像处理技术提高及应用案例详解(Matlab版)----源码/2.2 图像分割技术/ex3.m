I=imread('moli.jpg');
%rgb转灰度
if isrgb(I)==1
    I_gray=rgb2gray(I);
else
    I_gray=I;
end
subplot(121),imshow(I_gray);
%转化为双精度
I_double=double(I_gray); 
[wid,len]=size(I_gray);
%灰度级
colorlevel=256;  
%直方图
hist=zeros(colorlevel,1); 
%计算直方图
for i=1:wid
    for j=1:len
        m=I_gray(i,j)+1;
        hist(m)=hist(m)+1;
    end
end
%直方图归一化
hist=hist/(wid*len); 
miuT=0;
for m=1:colorlevel
    miuT=miuT+(m-1)*hist(m);
end
xigmaB2=0;
for mindex=1:colorlevel
    threshold=mindex-1;
    omega1=0;
    omega2=0;
    for m=1:threshold-1
          omega1=omega1+hist(m);
    end
    omega2=1-omega1;
    miu1=0;
    miu2=0;
    for m=1:colorlevel
        if m<threshold
           miu1=miu1+(m-1)*hist(m);
        else
           miu2=miu2+(m-1)*hist(m);
        end
    end
    miu1=miu1/omega1;
    miu2=miu2/omega2;
    xigmaB21=omega1*(miu1-miuT)^2+omega2*(miu2-miuT)^2;
    xigma(mindex)=xigmaB21;
    if xigmaB21>xigmaB2
        finalT=threshold;
        xigmaB2=xigmaB21;
    end
end
%阈值归一化
fT=finalT/255 
for i=1:wid
    for j=1:len
        if I_double(i,j)>finalT
            bin(i,j)=1;
        else
            bin(i,j)=0;
        end
    end
end
subplot(122),imshow(bin);
