function th=thresh_md(a) 
%功能：实现最大方差法计算分割门限 
%输入：a-为灰度图像
%输出: th-灰度分割门限 
%返回图像矩阵a各个灰度等级像素个数
count=imhist(a); 
[m,n]=size(a); 
N=m*n-sum(sum(find(a==0),1)); 
%指定图像灰度等级为256级
L=256; 
%计算出各灰度出现的概率
count=count/N; 
%找出出现概率不为0的最小灰度
for i=2:L 
  if count(i)~=0 
      st=i-1; 
      break; 
  end 
end 
%找出出现概率不为0的最大灰度
for i=L:-1:1 
    if count(i)~=0 
        nd=i-1; 
        break; 
    end 
end 
f=count(st+1:nd+1); 
%p和q分别为灰度起始和结束值
p=st; 
q=nd-st; 
%计算图像的平均灰度
u=0; 
for i=1:q 
    u=u+f(i)*(p+i-1); 
    ua(i)=u; 
end 
%计算出选择不同k值时，A区域的概率
for i=1:q 
    w(i)=sum(f(1:i)); 
end 
%求出不同k值时类间的方差
d=(u*w-ua).^2./(w.*(1-w)); 
%求出最大方差对应的灰度级
[y,tp]=max(d); 
th=tp+p; 
