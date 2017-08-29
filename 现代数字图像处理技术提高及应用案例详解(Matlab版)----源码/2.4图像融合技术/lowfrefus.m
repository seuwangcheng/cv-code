function y = lowfrefus(A,B);
% ���ܣ��������С���ֽ�ϵ�����󣬸����ں��㷨���ó��ں�ͼ��ĵ�ƵС���ֽ�ϵ��
%����ֽ�ϵ�������������
[row,col]=size(A);    
% alpha�Ƿ���ƥ��ȱȽϵ���ֵ
alpha=0.5;        
% ���ݵ�Ƶ�ں��㷨�����������A,B���Ե�PΪ���ĵ����򷽲�ͷ���ƥ���
for i=1:row        
for j=1:col        
% �ٸ��ݷ���ƥ�������ֵ�ıȽ�ȷ���ں�ͼ���С���ֽ�ϵ��     
[m2p(i,j),Ga(i,j),Gb(i,j)] = area_var_match(A,B,[i,j]);
        Wmin=0.2-0.5*((1-m2p(i,j))/(1-alpha));
        Wmax=1-Wmin;
       % m2p��ʾ����ƥ���
if m2p(i,j)<alpha        
            if Ga(i,j)>=Gb(i,j)        
% ��ƥ���С����ֵ����ȡ���򷽲�����Ӧ��ķֽ�ϵ����Ϊ�ں�ͼ��ķֽ�ϵ��
                y(i,j)=A(i,j);
            else
                y(i,j)=B(i,j);
            end
 % ��ƥ��ȴ�����ֵ�����ȡ��Ȩƽ�������ó���Ӧ�ķֽ�ϵ��
else               
            if Ga(i,j)>=Gb(i,j)
                y(i,j)=Wmax*A(i,j)+Wmin*B(i,j);
            else
                y(i,j)=Wmin*A(i,j)+Wmax*B(i,j);
            end
        end
    end
end
