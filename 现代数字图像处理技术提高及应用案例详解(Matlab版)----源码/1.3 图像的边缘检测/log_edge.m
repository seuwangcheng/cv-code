function e=log_edge(a, sigma)
%���ܣ�ʵ��LoG������ȡ��Ե��
%���룺a-�Ҷ�ͼ��
%      sigma-�˲�������
%�����e-��Եͼ��

%����ͬ����С�ı�Եͼ��e����ʼ��Ϊ0.
[m,n]=size(a);
e=repmat(logical(uint8(0)),m,n);
rr=2:m-1;cc=2:n-1;
%ѡ�����Ϊ�������˲����ĳߴ�fsize>6*sigma;
fsize=ceil(sigma*3)*2+1;
%����LoG�˲���
op=fspecial('log',fsize,sigma);
%��LoG�˲����ľ�ֵ��Ϊ0.
op=op-sum(op(:))/prod(size(op));
%����LoG���Ӷ�ͼ���˲�
b=filter2(op,a);
%���ù����������
%Ѱ���˲���Ĺ���㣬+-��-+��ʾˮƽ��������Һʹ��ҵ������
%[+-]'��[-+]'��ʾ��ֱ������ϵ��ºʹ��µ��Ϲ���
%��������ѡ���Ե��ΪֵΪ���ĵ�
thresh=.75*mean2(abs(b(rr,cc)));
%[- +]�����
[rx,cx]=find(b(rr,cc)<0&b(rr,cc+1)>0&abs(b(rr,cc)-b(rr,cc+1))>thresh) 
e((rx+1)+cx*m)=1;
%[- +]�����
[rx,cx]=find(b(rr,cc-1)>0&b(rr,cc)<0&abs(b(rr,cc-1)-b(rr,cc))>thresh) 
e((rx+1)+cx*m)=1;
%[- +]�����
[rx,cx]=find(b(rr,cc)<0&b(rr+1,cc)>0&abs(b(rr,cc)-b(rr+1,cc))>thresh) 
e((rx+1)+cx*m)=1;
%[- +]�����
[rx,cx]=find(b(rr-1,cc)>0&b(rr,cc)<0&abs(b(rr-1,cc)-b(rr,cc))>thresh) 
e((rx+1)+cx*m)=1;
%ĳЩ�����LoG�˲������������Ϊ0�����濼�����������
 %Ѱ���˲���Ĺ���
%+0-��-0+��ʾˮƽ��������Һʹ��ҵ������
%[+0-]'��[-0+]'��ʾ��ֱ������ϵ��ºʹ��µ��Ϲ���
%��Ե����λ���˲�ֵΪ�����
[rz,cz]=find(b(rr,cc)==0);
if~isempty(rz)
%������������
zero=(rz+1)+cz*m;   
%[-0+]�����
zz=find(b(zero-1)<0&b(zero+1)>0&abs(b(zero-1)-b(zero+1))>2*thresh);
e(zero(zz))=1;
%[+0-]'�����
zz=find(b(zero-1)>0&b(zero+1)<0&abs(b(zero-1)-b(zero+1))>2*thresh);
e(zero(zz))=1;
%[-0+]�����
zz=find(b(zero-m)<0&b(zero+m)>0&abs(b(zero-1)-b(zero+1))>2*thresh);
e(zero(zz))=1;
%[+0-]'�����
zz=find(b(zero-m)>0&b(zero+m)<0&abs(b(zero-1)-b(zero+1))>2*thresh);
e(zero(zz))=1;
end
