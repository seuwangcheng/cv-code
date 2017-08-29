%导入待融合图像1
 load bust
X1=X;
map1=map;
subplot(131);image(X1);
colormap(map1);title('原始图像1');
axis square
%导入待融合图像2
  load mask
X2=X;
map2=map;
 %对灰度值大于100的像素进行增强，小于100的像素进行减弱
 for i=1:256
     for j=1:256
        if(X2(i,j)>100)
           X2(i,j)=1.2*X2(i,j);
         else
            X2(i,j)=0.5*X2(i,j);
         end
      end
   end
subplot(132)
image(X2);colormap(map2);title('原始图像2');
axis square
%对原始图像1进行小波分解
[c1,s1]=wavedec2(X1,2,'sym4');
%对分解后的低频部分进行增强
sizec1=size(c1);
for I=1:sizec1(2)
       c1(I)=1.2*c1(I);
   end
%对原始图像2进行分解
[c2,s2]=wavedec2(X2,2,'sym4');
%将分解后的低频分量和高频分量进行相加，并乘以权重系数0.5
c=c1+c2;
c=0.5*c;
s=s1+s2;
s=0.5*s;
 %进行小波重构
xx=waverec2(c,s,'sym4');
subplot(133);image(xx);title('融合图像');
axis square
