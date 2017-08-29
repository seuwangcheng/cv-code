function G=gaussFilter(segma,kSize)
% ���ܣ�ʵ�ָ�˹�˲�
% ���룺
%     sigma-��˹�ֲ��ĸ����ܶȺ����ķ���
%     kSize-��˹������ģ��ߴ��С
% �����
%     G-����Ϊsegma����СΪkSize��һά��˹����ģ��

if nargin<1
    segma=1;
end
if nargin<2
    kSize=2*(segma*3);
end
 
x=-(kSize/2):(1+1/kSize):(kSize/2);
% ���þ�ֵΪ0������Ϊsegma��˹�ֲ������ܶȺ������һά��˹����ģ��
G=(1/(sqrt(2*pi)*segma)) * exp (-(x.^2)/(2*segma^2));
