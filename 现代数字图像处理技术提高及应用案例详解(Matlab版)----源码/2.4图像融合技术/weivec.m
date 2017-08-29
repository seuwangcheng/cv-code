function w = weivec(x,p)
%功能：对输入的r*c矩阵，计算出以点p为中心时矩阵各点的对应权值
% 距离点p越近，权值就越大。权值是通过行和列的高斯分布加权相加得到的
[r,c]=size(x);
p1=p(1);    p2=p(2);
sig=1;
for i=1:r
    for j=1:c
        w(i,j)=0.5*(gaussmf(i,[sig p1])+gaussmf(j,[sig p2]));
    end
end
