clear all; 
close all;
i=imread('yanjing.bmp'); 
imshow(i); 
iii=i; 
%������ͼ���ֵ������canny�㷨������ֵ
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
%���ҵ�һ����Ե��
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
%��һ����Ե��
o1=u1; 
o2=u2;
hang=zeros(0,0);
lie=zeros(0,0);
while (po==1)
   while (po==1)
         sum1=0;
         for t3=1:5
            for t4=1:5
               % ��һ����Ե������Ϸ�5���������б�Ե��
               if edgerm(u1-t3+1,u2+t4-1)==1                  
% ��һ����Ե����Χ�ı�Ե�����
sum1=sum1+1; 
                  sum2=sum2+1;
                  % ��sum1����Ե��λ��x
hang(sum1,1)=u1-t3+1;
                  % ��sum1����Ե��λ��y
hang(sum1,2)=u2+t4-1;
                  lie(sum2,1)=u1-t3+1;
                  lie(sum2,2)=u2+t4-1;
               end
            end
         end
         % ��Ե��ֻ��һ��
if sum1==1 
            po=0;
         % û�б�Ե��
elseif sum1==0 
            po=0;
         else
            % �����ı�Ե��Ϊ��㣬������һ������
u1=hang(sum1,1); 
            u2=hang(sum1,2);
            po=1;
         end
      end
      % ��Ե�����С��30��
if sum2<30 
         u1=o1;
         u2=o2+1;
         po=1;
         sum2=0;
      % �����겻�䣬�ı�������ֵ�õ���Ե��
while (edgerm(u1,u2)~=1)   
         while (edgerm(u1,u2)~=1)&(u2<310)
            % ���Ǳ�Ե�㣬�������1
u2=u2+1; 
         end 
         % û�еõ���Ե��
if u2==310 
            u1=u1-1;
            u2=1;
         end
      end
      % x���䣬�ı�y���µõ���Ե��
o1=u1; 
      o2=u2;
      else
         break;
      end  
   end 
% ��Ե�����
a1=size(lie); 
w1=lie(a1(1),1);
w2=lie(a1(1),2);
po1=1;
      while (po1==1)
         sum1=0;
         for t1=1:3
            for t2=1:5
               % ��Ե������3�����أ��Ϸ�5������
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
         % ��Ե��ֻ��һ��
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
%��ֹһ����Ե��
while (w1~=lie(1,1))&(w2~=lie(1,2)) 
         sum1=0;
         for t1=1:5
            for t2=1:5
               %��������5������������Ե��
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
      % ��ʼ��Hough����
e(t1,t2)=0; 
   end
end
% ��Ե�����
for t1=1:size(lie) 
   % ���Ǳ�Ե���λ����Ϊ1
e(lie(t1,1),lie(t1,2))=1;
end
%ȷ��ͫ�׵ı�Ե��������
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
% ���ö�ֵ���ķ������ͫ�׵����sum3
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
% �õ�ͫ��r1�뾶����ȡ��,sum3��ʾͫ�׵����
r1=ceil(sqrt(sum3/pi)); 
% ����ȡ�� �����ͫ��Բ��x����
c(1,1)=floor((maxh-minh)/2+minh); 
c(1,2)=ceil((maxl-minl)/2+minl);
r2=ceil(r1/3);
r3=2*r2;
for t1=1:ceil(r1/6)*2
   for t2=1:ceil(r1/6)*2
       pu(t1,t2)=0;
   end
end 
 %pu�д������ͬԲ�ĵ�ĸ�����������һ������pu��Ϊ��ͫ�׵�Բ��
 t1=minh;
 while t1<=maxh
    t2=minl;
    while t2<=maxl
      if (e(t1,t2)==1)
            for a=1:2*ceil(r1/6)
                for b=1:2*ceil(r1/6)
                  if (((t1-(c(1,1)+ceil(r1/6)-a))^2+(t2-(c(1,2)-ceil(r1/6)+b))^2-r1^2)>-10)&(((t1-(c(1,1)+ceil(r1/6)-a))^2+(t2-(c(1,2)-ceil(r1/6)+b))^2-r1^2)<10)
                      % ��a,bΪԲ�ĵ�Բ�ۼӸ���
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
% ѡȡͬ��Բ����Բ��
for a=1:2*ceil(r1/6) 
   for b=1:2*ceil(r1/6)
      if (ma<pu(a,b))
         ma=pu(a,b);
         row=a;
         col=b;
      end
   end
end
% Բ������
c(1,1)=c(1,1)+ceil(r1/6)-row; 
c(1,2)=c(1,2)-ceil(r1/6)+col;
j=double(i);
for t1=1:280
   for t2=1:320
%��Ĥ�ڱ�Ե��Ϊ��ɫ
     if ((t1-c(1,1))^2+(t2-c(1,2))^2-r1^2<80)&((t1-c(1,1))^2+(t2-c(1,2))^2-r1^2>-80)         
i(t1,t2)=255;
      end
   end
end

row1=c(1,1);
col1=c(1,2);
%�����ҵ�Բ�ģ�row1,col1),�뾶r1;
ha=row1;
li=col1;
sh1=1;
zong=0;
while sh1<=3
   sh2=1;
   while sh2<=3
      zong=zong+1;
      % Բ�����󡢲��䡢�����ƶ�2
row1=ha-4+sh1*2;
      col1=li-4+sh2*2;
      j1=double(i);    
      u=zeros(0,0);
        for t1=1:row1
            t2=col1;
               while t2<=310
                  %��һ���޵�ͼ��ԽǱ任
u(row1-t1+1,t2-col1+1)=j1(t1,t2); 
                  t2=t2+1;
               end
       end
u1=double(u);
%��һ����ͼ���������
yy=size(u); 
%ͫ�װ뾶r1
rr=r1+40; 
l1=r1+40;
l2=1;
ll1=0;
n1=l1;
sq1=0;
%yy(1,2)��ʾ��һ���޵ľ���������yy(1,1)����
while (l2<l1)&(l1<yy(1,2))&(l2<yy(1,1))
   pk=(l1-1/2)^2+(l2+1)^2-rr^2;
%�뾶��rr+40��Χ��
if pk<0 
      %����l1����Ҷ�ֵ�ۼ�
sq1=sq1+u1(l2+1,l1); 
      %��¼sql�ĸ���
ll1=ll1+1; 
      l1=l1;
      l2=l2+1;
   else sq1=sq1+u1(l2+1,l1-1);
      ll1=ll1+1;
      l1=l1-1;
      l2=l2+1;
   end
end
%�Ҷ�ƽ��ֵ
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
      % �ҳ��Ҷ�ֵ�仯����
ma1=sr1(t1); 
      % �뾶
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
%�����ǵ�������
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
%�����ǵڶ�����
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
% �����ǵ�������
% �ĸ����޵İ뾶ƽ��ֵ
ra(zong)=(rad1+rad2+rad3+rad4)/4; 
% Բ��λ��
xin(zong,1)=row1; 
xin(zong,2)=col1;
sh2=sh2+1;
% 4���������ҶȲ�ֵ��
ma(zong)=ma1+ma2+ma3+ma4; 
end
sh1=sh1+1;
end
max1=ma(1);
for t1=1:zong 
   if max1<=ma(t1)
      % ���ֵ�ǵ�t1��ѭ��
shh=t1; 
      % ѭ��������ҶȲ�ֵ
max1=ma(t1); 
   end
end
jing=0;
for t1=1:zong 
   jing=jing+ra(t1);
end
% ��Ĥ�뾶
jing=floor(jing/zong); 
% ��Ĥ��Բ��
row2=xin(shh,1); 
col2=xin(shh,2);
for t1=1:280
   for t2=1:320
      if ((t1-row2-2)^2+(t2-col2+4)^2-jing^2<200)&((t1-row2-2)^2+(t2-col2+4)^2-jing^2>-200) 
 %���ú�Ĥ���ԵΪ��ɫ
i(t1,t2)=255;
      end
   end
end
for t1=1:280
   for t2=1:320
      if ((t1-c(1,1))^2+(t2-c(1,2))^2<=r1^2)|((t1-c(1,1))^2+(t2-c(1,2))^2>=jing^2)         
%�Ѻ�Ĥ����Ĳ�����Ϊ��ɫ
iii(t1,t2)=255;
      end
   end
end
figure,imshow(i);
figure,imshow(iii);
