I=imread('moli.jpg');
%rgbת�Ҷ�
if isrgb(I)==1
    I_gray=rgb2gray(I);
else
    I_gray=I;
end
subplot(121),imshow(I_gray);
%ת��Ϊ˫����
I_double=double(I_gray); 
[wid,len]=size(I_gray);
%�Ҷȼ�
colorlevel=256;  
%ֱ��ͼ
hist=zeros(colorlevel,1); 
%����ֱ��ͼ
for i=1:wid
    for j=1:len
        m=I_gray(i,j)+1;
        hist(m)=hist(m)+1;
    end
end
%ֱ��ͼ��һ��
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
%��ֵ��һ��
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
