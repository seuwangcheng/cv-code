function [u, v] = HS(im1, im2, alpha, ite, uInitial, vInitial, displayFlow, displayImg)
% ���ܣ���������
% ���룺
%     im1-����ͼ��1
%     im2-����ͼ��2
%     alpha-��ӳHS�����㷨��ƽ����Լ�������Ĳ���
%     ita-��3.15.9��ʽ�еĵ�������
%     uInitial-�������������ʼֵ
%     vInitial-�������������ʼֵ
%     displayFlow-��������ʾ��������ֵΪ1ʱ��ʾ��Ϊ0ʱ����ʾ
%     displayImg-��ʾ��������ָ��ͼ�����Ϊ�վ�������ָ��ͼ�����
% �����
%     u-�������ʸ��
%     v-�������ʸ��

%  ��ʼ������
if nargin<1 || nargin<2
    im1=imread('HS1.tif');
    im2=imread('HS2.tif');
end
if nargin<3
    alpha=1;
end
if nargin<4
    ite=100;
end
if nargin<5 || nargin<6
    uInitial = zeros(size(im1(:,:,1)));
    vInitial = zeros(size(im2(:,:,1)));
elseif size(uInitial,1) ==0 || size(vInitial,1)==0
    uInitial = zeros(size(im1(:,:,1)));
    vInitial = zeros(size(im2(:,:,1)));
end
if nargin<7
    displayFlow=1;
end
if nargin<8
    displayImg=im1;
end
%  ��RGBͼ��ת��Ϊ�Ҷ�ͼ��
if size(size(im1),2)==3
    im1=rgb2gray(im1);
end
if size(size(im2),2)==3
    im2=rgb2gray(im2);
end
im1=double(im1);
im2=double(im2);
% ����ƽ����Լ��������ͼ�����ƽ��
im1=smoothImg(im1,1);
im2=smoothImg(im2,1);
tic;
% Ϊ����ʸ�����ó�ʼֵ
u = uInitial;
v = vInitial;
[fx, fy, ft] = computeDerivatives(im1, im2); % �����󵼺�����ʱ������Ϳռ����������
kernel_1=[1/12 1/6 1/12;1/6 0 1/6;1/12 1/6 1/12]; % ��ֵģ��
% ����ʽ��3.15.9��������⣬��������Ϊ100
for i=1:ite
    % �������ʸ���ľֲ���ֵ
    uAvg=conv2(u,kernel_1,'same');
    vAvg=conv2(v,kernel_1,'same');
    % ����ʽ��3.15.9���õ�����������ʸ��
    u= uAvg - ( fx .* ( ( fx .* uAvg ) + ( fy .* vAvg ) + ft ) ) ./ ( alpha^2 + fx.^2 + fy.^2); 
    v= vAvg - ( fy .* ( ( fx .* uAvg ) + ( fy .* vAvg ) + ft ) ) ./ ( alpha^2 + fx.^2 + fy.^2);
end
u(isnan(u))=0;
v(isnan(v))=0;
% ��ͼ
if displayFlow==1
   plotFlow(u, v, displayImg, 5, 5);  % ���û�ͼ����
end
