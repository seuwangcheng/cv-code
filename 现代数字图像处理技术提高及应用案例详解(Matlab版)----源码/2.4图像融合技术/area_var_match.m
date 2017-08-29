function [m2p,Ga,Gb] = area_var_match(A,B,p)
% ���ܣ�����������������Ե�pΪ���ĵ����򷽲��Լ����򷽲�ƥ���
% ��������Ĵ�С
level=1;    
[subA,mpa,npa]=submat(A,p,level);    
% submat ����ȡ����������Ե�PΪ���ġ�����Ϊ��2*level+1���ķ�����Ϊ�Ӿ���
[subB,mpb,npb]=submat(B,p,level);
[r,c]=size(subA);
% ��ȡ�Ӿ����Ȩֵ�ֲ�
w=weivec(subA,[mpa npa]);    
% �����Ӿ����ƽ��ֵ
averA=sum(sum(subA))/(r*c); 
averB=sum(sum(subB))/(r*c);
% �����Ӿ�������򷽲�
Ga=sum(sum(w.*(subA-averA).^2));    
Gb=sum(sum(w.*(subB-averB).^2));
% ���������Ӿ�������򷽲�ƥ���
if (Ga==0)&(Gb==0)      
    m2p=0;
else
    m2p=2*sum(sum(w.*abs(subA-averA).*abs(subB-averB)))/(Ga+Gb);
end
