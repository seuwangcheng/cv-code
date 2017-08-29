function  gmodify(pic,uv,gm,og) 
% 功能：对发生桶形畸变的数字图像进行校正
% 输入：pic-要处理的图像的路径文件名
%       uv-在发生畸变的图像上的点的坐标 
%       gm-在未发生畸变的图像上对应点的坐标 
%       og- 代表对称中心，它是一个二维向量
a=imread(pic);
b=double(a);
n=size(gm(:,1));
%转换到以对称点为原点的空间关系并构造矩阵A
for k=1:n
A(k,:)=[1,gm(k,1)-og(1),gm(k,2)-og(2),gm(k,1)-og(1)^2, (gm(k,1)-og(1))*(gm(k,2)-og(2)),(gm(k,2)-og(2))^2];
end
[h,w]=size(b(:,:,1));
sp=zeros(h,w,3)+255;
%计算地址映射的系数估计a
a0=pinv(A)* uv(:,2);  
%计算地址映射的系数估计b
b0=pinv(A)* uv(:,1);  
%从理想图像矩阵出发处理
for i=1:h     
   for j=1:w
    x=[1,j-og(1),i-og(2),(j-og(1))^2,(i-og(2))*(j-og(1)),(i-og(2))^2];  
     % 逆向映射（j，i）到畸变图像矩阵（v，u）
u=x*a0+og(2); 
    v=x*b0+og(1);  
    %处理在图像大小范围内的像素点
if (u>1)&&(u<w)&&(v>1)&&(v<h) 
     uu=floor(u);   
     vv=floor(v);   
     arf=u-uu;     
     bta=v-vv;    
     %进行灰度双线性插值
for k=1:3         
      ft1=(1-bta)*b(vv,uu,k)+bta*b(vv+1,uu,k); 
      ft2=(1-bta)*b(vv,uu+1,k)+bta*b(vv+1,uu+1,k);
      sp(i,j,k)=(1-arf)*ft1+arf*ft2; 
     end 
end
   end  
end
%显示校正图像
image(uint8(sp));      
