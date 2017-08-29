function myhough(x)
%该函数实现Hough变换提取直线的功能。
%输入图像x，运行之后直接画出直线
%输入的图像x为灰度图像
[m,n]=size(x);
%转换成二值图像
bw=edge(x,'prewitt')
%求出图像大小
md=round(sqrt(m^2+n^2));
%确定网格的最大区域
ma=180;
ruthta=zeros(md,ma);
%产生计数矩阵
ruthx=cell(1,1);
%cell数组相当于c语言中的指针，可动态改变大小
for i=1:md
    for j=1:ma
        ruthx{i,j}=[];
    end
end
%产生空网格
for i=5:m-4
    for j=5:n-4
        if bw(i,j)==1
            for k=1:ma
                ru=round(abs(j*cos(k)+i*sin(k)));
                %根据直线的法线式表示，计算出平面上不同点的hough变换值
                ruthta(ru+1,k)=ruthta(ru+1,k)+1;
                %将hough变换值相应位置的计数值加1
                ruthx{ru+1,k}=[ruthx{ru+1,k},[i,j]'];
                %记录hough变换值相应位置对应的点的坐标
            end
        end
    end
end
figure
bw=ones(size(bw));
imshow(bw);
N=1;%这里假设图像上有一条主要直线
for i=1:N
    %这里假定图像上有N条主要直线
    [y1,coll]=max(ruthta);
    [y2,row]=max(y1);
    %求出hough变换最大值的坐标
    col=coll(row);
    ruthta(col,row)=0;
    %为了避免重复计算将计算过的点置为0
    p=3;
    if col-p>0&col+p<md&row-p>0&row+p<ma
        rethta(col-p:col+p,row-p:row+p)=0;
    end
    nds=ruthx{col,row};
    pline=draw_l(nds);
end
function pline=draw_l(im)
%此函数实现根据在一条直线上点的坐标，计算出直线参数，并画出直线的功能。
y=im(1,:);
x=im(2,:);
mx=max(x);nx=min(x);
%确定直线在x方向的范围
my=max(y);ny=min(y);
%确定直线在y方向的范围
cx=mean(x);cy=mean(y);
%计算出直线的中心点坐标
xx=x-cx;yy=y-cy;
a=sum(xx.^2)-sum(xx)^2;
b=sum(xx.*yy)-sum(xx)*sum(yy);
c=sum(yy.^2)-sum(yy)^2;
Vs=(a+c)/2+sqrt((a-c)^2/4+b^2);
%利用最小二乘拟合直线，求出与直线有关的Vs
if abs((Vs-a)/(b+eps))<=1
    my=floor(cy+(Vs-a)/(b+eps)*(mx-cx));
    ny=floor(cy+(Vs-a)/(b+eps)*(nx-cx));
else
    mx=floor(cx+b/(Vs-a+eps)*(my-cy));
    nx=floor(cx+b/(Vs-a+eps)*(ny-cy));
end
%为避免斜率大于1时计算端点坐标误差过大，根据斜率值确定最大的x坐标或者y坐标
line([nx,mx],[ny,my]);
%画出直线
pline =[[nx,ny]',[mx,my]'];
