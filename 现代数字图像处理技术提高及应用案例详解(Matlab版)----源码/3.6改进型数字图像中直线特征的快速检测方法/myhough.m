function myhough(x)
%�ú���ʵ��Hough�任��ȡֱ�ߵĹ��ܡ�
%����ͼ��x������֮��ֱ�ӻ���ֱ��
%�����ͼ��xΪ�Ҷ�ͼ��
[m,n]=size(x);
%ת���ɶ�ֵͼ��
bw=edge(x,'prewitt')
%���ͼ���С
md=round(sqrt(m^2+n^2));
%ȷ��������������
ma=180;
ruthta=zeros(md,ma);
%������������
ruthx=cell(1,1);
%cell�����൱��c�����е�ָ�룬�ɶ�̬�ı��С
for i=1:md
    for j=1:ma
        ruthx{i,j}=[];
    end
end
%����������
for i=5:m-4
    for j=5:n-4
        if bw(i,j)==1
            for k=1:ma
                ru=round(abs(j*cos(k)+i*sin(k)));
                %����ֱ�ߵķ���ʽ��ʾ�������ƽ���ϲ�ͬ���hough�任ֵ
                ruthta(ru+1,k)=ruthta(ru+1,k)+1;
                %��hough�任ֵ��Ӧλ�õļ���ֵ��1
                ruthx{ru+1,k}=[ruthx{ru+1,k},[i,j]'];
                %��¼hough�任ֵ��Ӧλ�ö�Ӧ�ĵ������
            end
        end
    end
end
figure
bw=ones(size(bw));
imshow(bw);
N=1;%�������ͼ������һ����Ҫֱ��
for i=1:N
    %����ٶ�ͼ������N����Ҫֱ��
    [y1,coll]=max(ruthta);
    [y2,row]=max(y1);
    %���hough�任���ֵ������
    col=coll(row);
    ruthta(col,row)=0;
    %Ϊ�˱����ظ����㽫������ĵ���Ϊ0
    p=3;
    if col-p>0&col+p<md&row-p>0&row+p<ma
        rethta(col-p:col+p,row-p:row+p)=0;
    end
    nds=ruthx{col,row};
    pline=draw_l(nds);
end
function pline=draw_l(im)
%�˺���ʵ�ָ�����һ��ֱ���ϵ�����꣬�����ֱ�߲�����������ֱ�ߵĹ��ܡ�
y=im(1,:);
x=im(2,:);
mx=max(x);nx=min(x);
%ȷ��ֱ����x����ķ�Χ
my=max(y);ny=min(y);
%ȷ��ֱ����y����ķ�Χ
cx=mean(x);cy=mean(y);
%�����ֱ�ߵ����ĵ�����
xx=x-cx;yy=y-cy;
a=sum(xx.^2)-sum(xx)^2;
b=sum(xx.*yy)-sum(xx)*sum(yy);
c=sum(yy.^2)-sum(yy)^2;
Vs=(a+c)/2+sqrt((a-c)^2/4+b^2);
%������С�������ֱ�ߣ������ֱ���йص�Vs
if abs((Vs-a)/(b+eps))<=1
    my=floor(cy+(Vs-a)/(b+eps)*(mx-cx));
    ny=floor(cy+(Vs-a)/(b+eps)*(nx-cx));
else
    mx=floor(cx+b/(Vs-a+eps)*(my-cy));
    nx=floor(cx+b/(Vs-a+eps)*(ny-cy));
end
%Ϊ����б�ʴ���1ʱ����˵����������󣬸���б��ֵȷ������x�������y����
line([nx,mx],[ny,my]);
%����ֱ��
pline =[[nx,ny]',[mx,my]'];
