clear all; 
close all;
i=imread('yanjing.bmp'); 
imshow(i); 
iii=i; 
%把输入图象二值化，用canny算法返回阈值
sigma=3.0;
thresh=[0.03,0.09];
bw_1=i>70;
edgerm=edge(bw_1,'canny',thresh,sigma); 
figure,imshow(edgerm);
t1=280;
s=0;
while t1>10
t2=1;
while t2<310
%查找第一个边缘点
if edgerm(t1,t2)==1 
         u1=t1;
         u2=t2;
         s=1;
end
if s==1
   break;
end
  t2=t2+1;  
end
t1=t1-1;
end
po=1;
sum2=0;
%第一个边缘点
o1=u1; 
o2=u2;
hang=zeros(0,0);
lie=zeros(0,0);
while (po==1)
   while (po==1)
         sum1=0;
         for t3=1:5
            for t4=1:5
               % 第一个边缘点的左上方5个像素内有边缘点
               if edgerm(u1-t3+1,u2+t4-1)==1                  
% 第一个边缘点周围的边缘点个数
sum1=sum1+1; 
                  sum2=sum2+1;
                  % 第sum1个边缘点位置x
hang(sum1,1)=u1-t3+1;
                  % 第sum1个边缘点位置y
hang(sum1,2)=u2+t4-1;
                  lie(sum2,1)=u1-t3+1;
                  lie(sum2,2)=u2+t4-1;
               end
            end
         end
         % 边缘点只有一个
if sum1==1 
            po=0;
         % 没有边缘点
elseif sum1==0 
            po=0;
         else
            % 以最后的边缘点为起点，进行下一轮搜索
u1=hang(sum1,1); 
            u2=hang(sum1,2);
            po=1;
         end
      end
      % 边缘点个数小于30个
if sum2<30 
         u1=o1;
         u2=o2+1;
         po=1;
         sum2=0;
      % 横坐标不变，改变纵坐标值得到边缘点
while (edgerm(u1,u2)~=1)   
         while (edgerm(u1,u2)~=1)&(u2<310)
            % 不是边缘点，纵坐标加1
u2=u2+1; 
         end 
         % 没有得到边缘点
if u2==310 
            u1=u1-1;
            u2=1;
         end
      end
      % x不变，改变y重新得到边缘点
o1=u1; 
      o2=u2;
      else
         break;
      end  
   end 
% 边缘点个数
a1=size(lie); 
w1=lie(a1(1),1);
w2=lie(a1(1),2);
po1=1;
      while (po1==1)
         sum1=0;
         for t1=1:3
            for t2=1:5
               % 边缘点向左方3个像素，上方5个像素
if edgerm(w1-t1+1,w2-t2+1)==1 
                  sum1=sum1+1;
                  sum2=sum2+1;
                  lie(sum2,1)=w1-t1+1;
                  lie(sum2,2)=w2-t2+1;
                  hang(sum1,1)=w1-t1+1;
                  hang(sum1,2)=w2-t2+1;
               end
            end
         end   
         % 边缘点只有一个
if sum1==1 
            po1=0;
         else
            po1=1;
            w1=hang(sum1,1);
            w2=hang(sum1,2);
         end
      end

 po2=1;
 while (po2==1)
         sum1=0;
         for t1=1:7
            for t2=1:15
               if edgerm(w1+t1-1,w2-t2+1)==1 
                  sum1=sum1+1;
                  sum2=sum2+1;
                  lie(sum2,1)=w1+t1-1;
                  lie(sum2,2)=w2-t2+1;
                  hang(sum1,1)=w1+t1-1;
                  hang(sum1,2)=w2-t2+1;
               end
            end
         end   
         if sum1==1
            po2=0;
         else
            po2=1;
            w1=hang(sum1,1);
            w2=hang(sum1,2);
         end       
      end
%不止一个边缘点
while (w1~=lie(1,1))&(w2~=lie(1,2)) 
         sum1=0;
         for t1=1:5
            for t2=1:5
               %向右向上5个像素搜索边缘点
if edgerm(w1+t1-1,w2+t2-1)==1 
                  sum1=sum1+1;
                  sum2=sum2+1;
                  lie(sum2,1)=w1+t1-1;
                  lie(sum2,2)=w2+t2-1;
                  hang(sum1,1)=w1+t1-1;
                  hang(sum1,2)=w2+t2-1;
               end
            end
         end   
            w1=hang(sum1,1);
            w2=hang(sum1,2);
end      
for t1=1:280
   for t2=1:320
      % 初始化Hough矩阵
e(t1,t2)=0; 
   end
end
% 边缘点个数
for t1=1:size(lie) 
   % 将是边缘点的位置设为1
e(lie(t1,1),lie(t1,2))=1;
end
%确定瞳孔的边缘的上下限
minl=320;
maxl=1;
minh=280;
maxh=1;
for t1=1:280
   for t2=1:320
      if (e(t1,t2)==1)&(t2<minl)
         minl=t2;
      end
      if (e(t1,t2)==1)&(t2>maxl)
         maxl=t2;
      end
      if (e(t1,t2)==1)&(t1<minh)
         minh=t1;
      end
      if (e(t1,t2)==1)&(t1>maxh)
         maxh=t1;
      end       
   end
end
% 采用二值化的方法求得瞳孔的面积sum3
sum3=0;
t1=minh;
while t1<=maxh
   t2=minl;
   while t2<=maxl
      if (bw_1(t1,t2)==0) 
         sum3=sum3+1;
      end
      t2=t2+1;
   end
   t1=t1+1;
end
% 得到瞳孔r1半径向上取整,sum3表示瞳孔的面积
r1=ceil(sqrt(sum3/pi)); 
% 向下取整 估算出瞳孔圆心x坐标
c(1,1)=floor((maxh-minh)/2+minh); 
c(1,2)=ceil((maxl-minl)/2+minl);
r2=ceil(r1/3);
r3=2*r2;
for t1=1:ceil(r1/6)*2
   for t2=1:ceil(r1/6)*2
       pu(t1,t2)=0;
   end
end 
 %pu中存放有相同圆心点的个数，以下找一个最大的pu认为是瞳孔的圆心
 t1=minh;
 while t1<=maxh
    t2=minl;
    while t2<=maxl
      if (e(t1,t2)==1)
            for a=1:2*ceil(r1/6)
                for b=1:2*ceil(r1/6)
                  if (((t1-(c(1,1)+ceil(r1/6)-a))^2+(t2-(c(1,2)-ceil(r1/6)+b))^2-r1^2)>-10)&(((t1-(c(1,1)+ceil(r1/6)-a))^2+(t2-(c(1,2)-ceil(r1/6)+b))^2-r1^2)<10)
                      % 以a,b为圆心的圆累加个数
pu(a,b)=pu(a,b)+1; 
                  end
              end
          end
       end
       t2=t2+1;
    end
    t1=t1+1;
end
ma=pu(1,1);        
% 选取同心圆最多的圆心
for a=1:2*ceil(r1/6) 
   for b=1:2*ceil(r1/6)
      if (ma<pu(a,b))
         ma=pu(a,b);
         row=a;
         col=b;
      end
   end
end
% 圆心坐标
c(1,1)=c(1,1)+ceil(r1/6)-row; 
c(1,2)=c(1,2)-ceil(r1/6)+col;
j=double(i);
for t1=1:280
   for t2=1:320
%虹膜内边缘设为白色
     if ((t1-c(1,1))^2+(t2-c(1,2))^2-r1^2<80)&((t1-c(1,1))^2+(t2-c(1,2))^2-r1^2>-80)         
i(t1,t2)=255;
      end
   end
end

row1=c(1,1);
col1=c(1,2);
%以上找到圆心（row1,col1),半径r1;
ha=row1;
li=col1;
sh1=1;
zong=0;
while sh1<=3
   sh2=1;
   while sh2<=3
      zong=zong+1;
      % 圆心向左、不变、向右移动2
row1=ha-4+sh1*2;
      col1=li-4+sh2*2;
      j1=double(i);    
      u=zeros(0,0);
        for t1=1:row1
            t2=col1;
               while t2<=310
                  %第一像限的图像对角变换
u(row1-t1+1,t2-col1+1)=j1(t1,t2); 
                  t2=t2+1;
               end
       end
u1=double(u);
%第一像限图像的行列数
yy=size(u); 
%瞳孔半径r1
rr=r1+40; 
l1=r1+40;
l2=1;
ll1=0;
n1=l1;
sq1=0;
%yy(1,2)表示第一像限的矩阵列数，yy(1,1)行数
while (l2<l1)&(l1<yy(1,2))&(l2<yy(1,1))
   pk=(l1-1/2)^2+(l2+1)^2-rr^2;
%半径在rr+40范围内
if pk<0 
      %沿着l1方向灰度值累加
sq1=sq1+u1(l2+1,l1); 
      %记录sql的个数
ll1=ll1+1; 
      l1=l1;
      l2=l2+1;
   else sq1=sq1+u1(l2+1,l1-1);
      ll1=ll1+1;
      l1=l1-1;
      l2=l2+1;
   end
end
%灰度平均值
sq=sq1/ll1; 
for t1=r1+40:126
   sr1(t1)=0;
end
rr=rr+2;
l1=n1+2;
l2=1;
while (rr<=126)&(rr<sqrt(2)*yy(1,2))&(rr<sqrt(2)*yy(1,1))&(l1>l2)&(l1<yy(1,2))&(l2<yy(1,1))
   n1=l1;
   ll2=0;
   sq2=0;
   while (l1>l2)&(l1<yy(1,2))&(l2<yy(1,1))
      pk=(l1-1/2)^2+(l2+1)^2-rr^2;
      if pk<0
         sq2=sq2+u1(l2+1,l1);
         ll2=ll2+1;
         l1=l1;
         l2=l2+1;
      else sq2=sq2+u1(l2+1,l1-1);
         ll2=ll2+1;
         l1=l1-1;
         l2=l2-1;
      end
   end
   sqq=sq2/ll2;
   sr1(rr)=abs(sqq-sq);
   sq=sqq;
   rr=rr+2;
   l1=n1+2;
   l2=1;
end
ma1=sr1(r1+40);
t1=r1+40;
while t1<=126
   if sr1(t1)>ma1
      % 找出灰度值变化最大点
ma1=sr1(t1); 
      % 半径
rad1=t1; 
   end
   t1=t1+1;
end

q1=zeros(0,0);
t1=row1;
while t1<280
   t2=col1;
   while t2<310
      q1(t1-row1+1,t2-col1+1)=j1(t1,t2);
      t2=t2+1;
   end
   t1=t1+1;
end
yy1=double(q1);
ys1=size(yy1);
rr1=r1+40;
l21=r1+40;
l22=1;
ll3=0;
n2=l21;
sq3=0;
while (l22<l21)&(l21<ys1(1,2))&(l22<ys1(1,1))
   pk1=(l21-1/2)^2+(l22+1)^2-rr1^2;
   if pk1<0
      sq3=sq3+yy1(l22+1,l21);
      ll3=ll3+1;
      l21=l21;
      l22=l22+1;
   else sq3=sq3+yy1(l22+1,l21-1);
      ll3=ll3+1;
      l21=l21-1;
      l22=l22+1;
   end
end
sq=sq3/ll3;
for t1=r1+40:126
   sr2(t1)=0;
end
rr1=rr1+2;
l21=n2+2;
l22=1;
while (rr1<=126)&(rr1<sqrt(2)*ys1(1,2))&(rr1<sqrt(2)*ys1(1,1))&(l21>l22)&(l21<ys1(1,2))&(l22<ys1(1,1))
   n2=l21;
   ll4=0;
   sq4=0;
   while (l21>l22)&(l21<ys1(1,2))&(l22<ys1(1,1))
      pk1=(l21-1/2)^2+(l22+1)^2-rr1^2;
      if pk1<0
         sq4=sq4+yy1(l22+1,l21);
         ll4=ll4+1;
         l21=l21;
         l22=l22+1;
       else sq4=sq4+yy1(l22+1,l21-1);
         ll4=ll4+1;
         l21=l21-1;
         l22=l22+1;
       end
   end
   sqq=sq4/ll4;
   sr2(rr1)=abs(sqq-sq);
   sq=sqq;
   rr1=rr1+2;
   l21=n2+2;
   l22=1;
end

ma2=sr2(r1+40);
t1=r1+40;
while t1<=126
   if sr2(t1)>ma2
      ma2=sr2(t1);
      rad2=t1;
   end
   t1=t1+1;
end
%以上是第四向限
q2=zeros(0,0);
for t1=1:row1
   for t2=1:col1
      q2(row1+1-t1,col1+1-t2)=j1(t1,t2);
   end
end
yy2=double(q2);
ys2=size(yy2);
rr2=r1+40;
l31=r1+40;
l32=1;
ll5=0;
n3=l31;
sq5=0;
while (l32<l31)&(l31<ys2(1,2))&(l32<ys2(1,1))
   pk2=(l31-1/2)^2+(l32+1)^2-rr2^2;
   if pk2<0
      sq5=sq5+yy2(l32+1,l31);
      ll5=ll5+1;
      l31=l31;
      l32=l32+1;
   else sq5=sq5+yy2(l32+1,l31-1);
      ll5=ll5+1;
      l31=l31-1;
      l32=l32+1;
   end
end
sq=sq5/ll5;
for t1=r1+40:126
   sr3(t1)=0;
end
rr2=rr2+2;
l31=n3+2;
l32=1;
while (rr2<=126)&(rr2<sqrt(2)*ys2(1,2))&(rr2<sqrt(2)*ys2(1,1))&(l31>l32)&(l31<ys2(1,2))&(l32<ys2(1,1))
   n3=l31;
   ll6=0;
   sq6=0;
   while (l31>l32)&(l31<ys2(1,2))&(l32<ys2(1,1))
      pk2=(l31-1/2)^2+(l32+1)^2-rr2^2;
      if pk2<0
         sq6=sq6+yy2(l32+1,l31);
         ll6=ll6+1;
         l31=l31;
         l32=l32+1;
      else sq6=sq6+yy2(l32+1,l31-1);
         ll6=ll6+1;
         l31=l31-1;
         l32=l32+1;
      end
   end
   sqq=sq6/ll6;
   sr3(rr2)=abs(sqq-sq);
   sq=sqq;
   rr2=rr2+2;
   l31=n3+2;
   l32=1;
end
ma3=sr3(r1+40);
t1=r1+40;
while t1<=126
   if sr3(t1)>ma3
      ma3=sr3(t1);
      rad3=t1;
   end
   t1=t1+1;
end
%以上是第二向限
j1=double(i);
q3=zeros(0,0);
t1=row1;
while t1<280
   for t2=1:col1
      q3(t1-row1+1,col1+1-t2)=j1(t1,t2);
   end
   t1=t1+1;
end
yy3=double(q3);
ys3=size(yy3);
rr3=r1+40;
l41=r1+40;
l42=1;
ll7=0;
n4=l41;
sq7=0;
while (l42<l41)&(l41<ys3(1,2))&(l42<ys3(1,1))
   pk3=(l41-1/2)^2+(l42+1)^2-rr3^2;
   if pk3<0
      sq7=sq7+yy3(l42+1,l41);
      ll7=ll7+1;
      l41=l41;
      l42=l42+1;
   else sq7=sq7+yy3(l42+1,l41-1);
      ll7=ll7+1;
      l41=l41-1;
      l42=l42+1;
   end
end
sq=sq7/ll7;
for t1=r1+40:126
   sr4(t1)=0;
end
rr3=rr3+2;
l41=n4+2;
l42=1;
while (rr3<=126)&(rr3<sqrt(2)*ys3(1,2))&(rr3<sqrt(2)*ys3(1,1))&(l41>l42)&(l41<ys3(1,2))&(l42<ys3(1,1))
   n4=l41;
   ll8=0;
   sq8=0;
   while (l41>l42)&(l41<ys3(1,2))&(l42<ys3(1,1))
      pk3=(l41-1/2)^2+(l42+1)^2-rr3^2;
      if pk3<0
         sq8=sq8+yy3(l42+1,l41);
         ll8=ll8+1;
         l41=l41;
         l42=l42+1;
      else sq8=sq8+yy3(l42+1,l41-1);
         ll8=ll8+1;
         l41=l41-1;
         l42=l42+1;
      end
   end
   sqq=sq8/ll8;
   sr4(rr3)=abs(sqq-sq);
   sq=sqq;
   rr3=rr3+2;
   l41=n4+2;
   l42=1;
end
ma4=sr4(r1+40);
t1=r1+40;
while t1<=126
   if sr4(t1)>ma4
      ma4=sr4(t1);
      rad4=t1;
   end
   t1=t1+1;
end
% 以上是第三向限
% 四个像限的半径平均值
ra(zong)=(rad1+rad2+rad3+rad4)/4; 
% 圆心位置
xin(zong,1)=row1; 
xin(zong,2)=col1;
sh2=sh2+1;
% 4个像限最大灰度差值和
ma(zong)=ma1+ma2+ma3+ma4; 
end
sh1=sh1+1;
end
max1=ma(1);
for t1=1:zong 
   if max1<=ma(t1)
      % 最大值是第t1次循环
shh=t1; 
      % 循环后的最大灰度差值
max1=ma(t1); 
   end
end
jing=0;
for t1=1:zong 
   jing=jing+ra(t1);
end
% 虹膜半径
jing=floor(jing/zong); 
% 虹膜的圆心
row2=xin(shh,1); 
col2=xin(shh,2);
for t1=1:280
   for t2=1:320
      if ((t1-row2-2)^2+(t2-col2+4)^2-jing^2<200)&((t1-row2-2)^2+(t2-col2+4)^2-jing^2>-200) 
 %设置虹膜外边缘为白色
i(t1,t2)=255;
      end
   end
end
for t1=1:280
   for t2=1:320
      if ((t1-c(1,1))^2+(t2-c(1,2))^2<=r1^2)|((t1-c(1,1))^2+(t2-c(1,2))^2>=jing^2)         
%把虹膜以外的部分设为白色
iii(t1,t2)=255;
      end
   end
end
figure,imshow(i);
figure,imshow(iii);
