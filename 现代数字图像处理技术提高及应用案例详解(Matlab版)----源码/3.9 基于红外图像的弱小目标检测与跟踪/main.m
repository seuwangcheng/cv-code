clear
%���ɴ�����ͼ��im1��
im1=0.6*ones(128,128);
im1(80,90)=256;
im1(100,100)=256;
imshow(im1)
% ȷ������Ĵ�С��5��5��
r=2;                      
k=1;
% ���ñ�д�ĺ�������ͼ��ľ���Ҷȸ��ʾ���
P=target_detect(im1,r);      
figure
mesh(P)
%�������㣻
[Pr Pc]=find(P>k/(2*r+1)^2+0.1);  
figure
imshow(im1)
hold on                    
% ��ͼ��im1�ϱ����⵽������㣻
for i=1:length(Pr)           
plot(Pc(i),Pr(i),'g+')
end
hold on
im2=0.6*ones(128,128);
im2(81,90)=256;
im2(200,200)=256;
r1=1;
k1=1;
% �����һ֡ͼ���������λ�ã���һ֡��⵽�ģ����������Ƿ��������㣻
P1=target_refine(Pr,Pc,im2,r1);  
%ȷ��������λ�ã�
[Prt Pct]=find(P1>k1/(2*r1+1)^2+0.1);  
% ������ռ�⵽��СĿ��
for i=1:length(Prt)              
  plot(Pct(i),Prt(i),'ro');
end
