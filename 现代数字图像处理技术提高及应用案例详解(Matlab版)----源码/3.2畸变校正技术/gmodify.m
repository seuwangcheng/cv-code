function  gmodify(pic,uv,gm,og) 
% ���ܣ��Է���Ͱ�λ��������ͼ�����У��
% ���룺pic-Ҫ�����ͼ���·���ļ���
%       uv-�ڷ��������ͼ���ϵĵ������ 
%       gm-��δ���������ͼ���϶�Ӧ������� 
%       og- ����Գ����ģ�����һ����ά����
a=imread(pic);
b=double(a);
n=size(gm(:,1));
%ת�����ԶԳƵ�Ϊԭ��Ŀռ��ϵ���������A
for k=1:n
A(k,:)=[1,gm(k,1)-og(1),gm(k,2)-og(2),gm(k,1)-og(1)^2, (gm(k,1)-og(1))*(gm(k,2)-og(2)),(gm(k,2)-og(2))^2];
end
[h,w]=size(b(:,:,1));
sp=zeros(h,w,3)+255;
%�����ַӳ���ϵ������a
a0=pinv(A)* uv(:,2);  
%�����ַӳ���ϵ������b
b0=pinv(A)* uv(:,1);  
%������ͼ������������
for i=1:h     
   for j=1:w
    x=[1,j-og(1),i-og(2),(j-og(1))^2,(i-og(2))*(j-og(1)),(i-og(2))^2];  
     % ����ӳ�䣨j��i��������ͼ�����v��u��
u=x*a0+og(2); 
    v=x*b0+og(1);  
    %������ͼ���С��Χ�ڵ����ص�
if (u>1)&&(u<w)&&(v>1)&&(v<h) 
     uu=floor(u);   
     vv=floor(v);   
     arf=u-uu;     
     bta=v-vv;    
     %���лҶ�˫���Բ�ֵ
for k=1:3         
      ft1=(1-bta)*b(vv,uu,k)+bta*b(vv+1,uu,k); 
      ft2=(1-bta)*b(vv,uu+1,k)+bta*b(vv+1,uu+1,k);
      sp(i,j,k)=(1-arf)*ft1+arf*ft2; 
     end 
end
   end  
end
%��ʾУ��ͼ��
image(uint8(sp));      
