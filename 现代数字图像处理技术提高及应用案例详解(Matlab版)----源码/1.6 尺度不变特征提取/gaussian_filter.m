function g = gaussian_filter( sigma)
 
% ���ܣ�����һά��˹�˲���
% ���룺
% sigma �C ��˹�˲����ı�׼��
% �����
% g �C ��˹�˲���

   sample = 7.0/2.0;

n = 2*round(sample * sigma)+1;
 
x=1:n;
x=x-ceil(n/2);
 
g = exp(-(x.^2)/(2*sigma^2))/(sigma*sqrt(2*pi));
