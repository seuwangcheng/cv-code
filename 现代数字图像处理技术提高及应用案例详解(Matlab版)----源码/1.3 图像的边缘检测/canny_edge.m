function e=canny_edge(a,sigma)
%���ܣ�ʵ��Canny���ӱ�Ե���
%���룺a- m��m�ĻҶ�ͼ��
%     sigma-��׼��
%�����e-�����ı�Ե
[m,n]=size(a);
a=double(a);
rr=2:m-1;cc=2:n-1;
%%%%%%%��ʼ����Ե����%%%%%%
e=repmat(logical(uint8(0)),m,n);
%�趨��˹������ʧ����
GaussianDieOff=-0001; 
%���ڼ����Ե����
PercentOfPixelsNotEdge=-7 
%�����������޵ı���
ThresholdRatio=-4; 
%%%%%%������Ƹ�˹�˲���������΢��%%%%%%
%�趨�˲������
pw=1:30;
%���㷽��
ssq=sigma*sigma;
%�����˲��ӿ��
width=max(find(exp(-(pw.*pw)/(2*sigma*sigma))>GaussianDieOff));
t=(-width:width);
len=2*width+1;
%��ÿ���������Ҹ���λ�õ�ֵ����ƽ��
t3=[t-.5;t;t+.5];
%һά��˹�˲���
gau=sum(exp(-(t3.*t3)/(2*ssq))).'/(6*pi*ssq);
%��˹�˲�����΢��
dgau=(-t.*exp(-(t.*t)/(2*ssq))/ssq);
ra=size(a,1);
ca=size(a,2);
ay=255*a;ax=255*a';
%���ø�˹�����˳��������ø�˹���ӵ�һ��΢�ֶ�ͼ���˲��ϲ�Ϊһ������
h=conv(gau,dgau);
%����x�����˲�
ax=conv2(ax,h,'same').';
%����y�����˲�
ay=conv2(ay,h,'same').';
%�����˲�����ķ���
mag=sqrt((ax.*ax)+(ay.*ay));
magmax=max(mag(:));
if magmax>0
   %���˲����Ƚ��й�һ��
 mag=mag/magmax;
end
%%%%%%��������˲����ȵĸ����ܶȼ����˲�����%%%%%%
%�����˲�����ķ��ȵ�ֱ��ͼ
[counts,x]=imhist(mag,64);
%ͨ���趨�Ǳ�Ե��ı�����ȷ��������

highThresh=min(find(cumsum(counts)>PercentOfPixelsNotEdge*m*n))/64;
%���õ�����Ϊ�����޳��Ա�������
lowThresh=ThresholdRatio*highThresh;
thresh=[lowThresh highThresh];
%%%%%%������зǼ�������%%%%%%
%%%%%%���ڸ����޵ĵ����ǿ��Եͼ��%%%%%%
%%%%%%С�ڵ����޵ĵ����������ͼ��%%%%%%
idxStrong=[];
for dir=1:4
    idxLocalMax=cannyFindLocalMaxima(dir,ax,ay,mag);
    idxWeak=idxLocalMax(mag(idxLocalMax)>lowThresh);
    e(idxWeak)=1;
    idxStrong=[idxStrong;idxWeak(mag(idxWeak)>highThresh)];
end
rstrong=rem(idxStrong-1,m)+1;
cstrong=floor((idxStrong-1)/m)+1;
%ͨ����̬ѧ���ӽ�����ͼ��ı�Ե��������
e=bwselect(e,cstrong,rstrong,8);
%����ȡ�ı�Ե������̬ѧ����ϸ��
e=bwmorph(e,'thin',1);
