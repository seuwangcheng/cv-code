function P=target_detect(im,r)
% 功能:计算图像局域灰度概率矩阵
% 输入:im-RGB图像        r-局域半径
% 输出:P-局域灰度概率矩阵

% P-图像转换
if size(size(im),2)==3
im=rgb2gray(im); 
end
[m,n]=size(im);
local_region=zeros(2*r+1,2*r+1); 
% 计算局域概率矩阵
for i=r+1:m-r
  for j=r+1:n-r
    local_region=im(i-r:i+r,j-r:j+r);
    P(i,j)=im(i,j)/sum(sum(local_region));
  end
end
