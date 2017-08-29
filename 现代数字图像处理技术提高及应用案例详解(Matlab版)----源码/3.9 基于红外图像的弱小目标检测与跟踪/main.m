clear
%生成待检测的图像im1；
im1=0.6*ones(128,128);
im1(80,90)=256;
im1(100,100)=256;
imshow(im1)
% 确定邻域的大小：5×5；
r=2;                      
k=1;
% 调用编写的函数计算图像的局域灰度概率矩阵；
P=target_detect(im1,r);      
figure
mesh(P)
%检测奇异点；
[Pr Pc]=find(P>k/(2*r+1)^2+0.1);  
figure
imshow(im1)
hold on                    
% 在图像im1上标出检测到的奇异点；
for i=1:length(Pr)           
plot(Pc(i),Pr(i),'g+')
end
hold on
im2=0.6*ones(128,128);
im2(81,90)=256;
im2(200,200)=256;
r1=1;
k1=1;
% 检测下一帧图像中奇异点位置（上一帧检测到的）附近邻域是否存在奇异点；
P1=target_refine(Pr,Pc,im2,r1);  
%确定奇异点的位置；
[Prt Pct]=find(P1>k1/(2*r1+1)^2+0.1);  
% 标出最终检测到的小目标
for i=1:length(Prt)              
  plot(Pct(i),Prt(i),'ro');
end
