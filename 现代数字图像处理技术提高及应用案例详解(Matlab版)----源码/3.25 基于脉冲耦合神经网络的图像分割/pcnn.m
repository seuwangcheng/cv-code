function [Edge,Numberofaera]=pcnn(X)
% ���ܣ�����PCNN�㷨���б�Ե���
% ���룺X������ĻҶ�ͼ��
% �����Edge����⵽��       Numberofaera���������ڸ��ε���ʱ����Ŀ�����
figure(1);
imshow(X); 
X=double(X);
% �趨Ȩֵ
Weight=[0.07 0.1 0.07;0.1 0 0.1;0.07 0.1 0.07]; 
WeightLI2=[-0.03 -0.03 -0.03;-0.03 0 -0.03;-0.03 -0.03 -0.03];
d=1/(1+sum(sum(WeightLI2)));
%%%%%%����Ȩֵ%%%%%%
WeightLI=[-0.03 -0.03 -0.03;-0.03 0.5 -0.03;-0.03 -0.03 -0.03];
d1=1/(sum(sum(WeightLI)));
%%%%%%%%%%%%%%%%%%
Beta=0.4;  
Yuzhi=245;
%˥��ϵ��
Decay=0.3;   
[a,b]=size(X);
V_T=0.2;
%����ֵ
Threshold=zeros(a,b);  
S=zeros(a+2,b+2);
Y=zeros(a,b);
%���Ƶ��
Firate=zeros(a,b); 
n=1;
%ͳ��ѭ������
count=0; 
Tempu1=zeros(a,b); 
Tempu2=zeros(a+2,b+2); 
%%%%%%ͼ����ǿ����%%%%%%
Out=zeros(a,b);
Out=uint8(Out);
for i=1:a
for j=1:b
 if(i==1|j==1|i==a|j==b)
  Out(i,j)=X(i,j);
 else  
  H=[X(i-1,j-1)  X(i-1,j) X(i-1,j+1);
     X(i,j-1)   X(i,j)   X(i,j+1);
    X(i+1,j-1) X(i+1,j) X(i+1,j+1)]; 
 temp=d1*sum(sum(H.*WeightLI));
 Out(i,j)=temp;
 end
 end
end
figure(2);
imshow(Out); 
%%%%%%%%%%%%%%%%%%%
for count=1:30 
 for i0=2:a+1
    for i1=2:b+1
         V=[S(i0-1,i1-1)  S(i0-1,i1) S(i0-1,i1+1);
             S(i0,i1-1)   S(i0,i1)   S(i0,i1+1);
             S(i0+1,i1-1) S(i0+1,i1) S(i0+1,i1+1)];
           L=sum(sum(V.*Weight));
           V2=[Tempu2(i0-1,i1-1)  Tempu2(i0-1,i1) Tempu2(i0-1,i1+1);
               Tempu2(i0,i1-1)   Tempu2(i0,i1)   Tempu2(i0,i1+1);
               Tempu2(i0+1,i1-1) Tempu2(i0+1,i1) Tempu2(i0+1,i1+1)];        F=X(i0-1,i1-1)+sum(sum(V2.*WeightLI2));
%��֤������ͼ����������ʧ
F=d*F; 
U=double(F)*(1+Beta*double(L));                          
Tempu1(i0-1,i1-1)=U;
    if U>=Threshold(i0-1,i1-1)|Threshold(i0-1,i1-1)<60
      T(i0-1,i1-1)=1;
      Threshold(i0-1,i1-1)=Yuzhi;
       %����һֱ��Ϊ1
Y(i0-1,i1-1)=1;    
     else
        T(i0-1,i1-1)=0;
        Y(i0-1,i1-1)=0;
                 end
            end
         end
   Threshold=exp(-Decay)*Threshold+V_T*Y;
   %������������ز��ٲ����������
     if n==1
        S=zeros(a+2,b+2);
        else
        S=Bianhuan(T);
     end
     n=n+1;
     count=count+1; 
     Firate=Firate+Y;
    figure(3);
    imshow(Y);
    Tempu2=Bianhuan(Tempu1);
end
   Firate(find(Firate<10))=0;
   Firate(find(Firate>=10))=10;
   figure(4);
   imshow(Firate);
%%%%%%�Ӻ��� %%%%%%%
function Y=Jiabian(X)
[m,n]=size(X);
Y=zeros(m+2,n+2);
for i=1:m+2
    for j=1:n+2
        if i==1&j~=1&j~=n+2
            Y(i,j)=X(1,j-1);
        elseif j==1&i~=1&i~=m+2
            Y(i,j)=X(i-1,1);
        elseif i~=1&j==n+2&i~=m+2
            Y(i,j)=X(i-1,n);
        elseif i==m+2&j~=1&j~=n+2
            Y(i,j)=X(m,j-1);
        elseif i==1&j==1
            Y(i,j)=X(i,j);
        elseif i==1&j==n+2
            Y(i,j)=X(1,n);
        elseif i==(m+2)&j==1
            Y(i,j)=X(m,1);
        elseif i==m+2&j==n+2
            Y(i,j)=X(m,n);
        else
            Y(i,j)=X(i-1,j-1);
        end
    end
end
%%%%%%�Ӻ���%%%%%%
function Y=Bianhuan(X)
[m,n]=size(X);
Y=zeros(m+2,n+2);
for i=1:m+2
    for j=1:n+2
        if i==1|j==1|i==m+2|j==n+2
            Y(i,j)=0;
        else
            Y(i,j)=X(i-1,j-1);
        end
    end
end
%%%%%%�Ӻ���%%%%%%
function Y=judge_edge(X,n)
%X:ÿ�ε�����PCNN����Ķ�ֵͼ�����׼ȷ�жϱ߽���ǹؼ�
[a,b]=size(X);
T=Jiabian(X);
Y=zeros(a,b);
W=zeros(a,b);
for i=2:a+1
    for j=2:b+1
        if (T(i,j)==1)&((T(i-1,j)==0&T(i+1,j)==0)|(T(i,j-1)==0&T(i,j+1)==0)|(T(i-1,j-1)==0&T(i+1,j+1)==0)|(T(i+1,j-1)==0&T(i-1,j+1)==0))
            Y(i-1,j-1)=-n;
        end
    end
end
