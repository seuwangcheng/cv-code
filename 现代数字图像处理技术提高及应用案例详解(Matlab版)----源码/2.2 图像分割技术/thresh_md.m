function th=thresh_md(a) 
%���ܣ�ʵ����󷽲����ָ����� 
%���룺a-Ϊ�Ҷ�ͼ��
%���: th-�Ҷȷָ����� 
%����ͼ�����a�����Ҷȵȼ����ظ���
count=imhist(a); 
[m,n]=size(a); 
N=m*n-sum(sum(find(a==0),1)); 
%ָ��ͼ��Ҷȵȼ�Ϊ256��
L=256; 
%��������Ҷȳ��ֵĸ���
count=count/N; 
%�ҳ����ָ��ʲ�Ϊ0����С�Ҷ�
for i=2:L 
  if count(i)~=0 
      st=i-1; 
      break; 
  end 
end 
%�ҳ����ָ��ʲ�Ϊ0�����Ҷ�
for i=L:-1:1 
    if count(i)~=0 
        nd=i-1; 
        break; 
    end 
end 
f=count(st+1:nd+1); 
%p��q�ֱ�Ϊ�Ҷ���ʼ�ͽ���ֵ
p=st; 
q=nd-st; 
%����ͼ���ƽ���Ҷ�
u=0; 
for i=1:q 
    u=u+f(i)*(p+i-1); 
    ua(i)=u; 
end 
%�����ѡ��ͬkֵʱ��A����ĸ���
for i=1:q 
    w(i)=sum(f(1:i)); 
end 
%�����ͬkֵʱ���ķ���
d=(u*w-ua).^2./(w.*(1-w)); 
%�����󷽲��Ӧ�ĻҶȼ�
[y,tp]=max(d); 
th=tp+p; 
