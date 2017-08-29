function [u, v] = HS(im1, im2, alpha, ite, uInitial, vInitial, displayFlow, displayImg)
% 功能：求解光流场
% 输入：
%     im1-输入图像1
%     im2-输入图像2
%     alpha-反映HS光流算法的平滑性约束条件的参数
%     ita-（3.15.9）式中的迭代次数
%     uInitial-光流横向分量初始值
%     vInitial-光流纵向分量初始值
%     displayFlow-光流场显示参数，其值为1时显示，为0时不显示
%     displayImg-显示光流场的指定图像，如果为空矩阵，则无指定图像输出
% 输出：
%     u-横向光流矢量
%     v-纵向光流矢量

%  初始化参数
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
%  将RGB图像转化为灰度图像
if size(size(im1),2)==3
    im1=rgb2gray(im1);
end
if size(size(im2),2)==3
    im2=rgb2gray(im2);
end
im1=double(im1);
im2=double(im2);
% 调用平滑性约束函数对图像进行平滑
im1=smoothImg(im1,1);
im2=smoothImg(im2,1);
tic;
% 为光流矢量设置初始值
u = uInitial;
v = vInitial;
[fx, fy, ft] = computeDerivatives(im1, im2); % 调用求导函数对时间分量和空间分量进行求导
kernel_1=[1/12 1/6 1/12;1/6 0 1/6;1/12 1/6 1/12]; % 均值模板
% 根据式（3.15.9）迭代求解，迭代次数为100
for i=1:ite
    % 计算光流矢量的局部均值
    uAvg=conv2(u,kernel_1,'same');
    vAvg=conv2(v,kernel_1,'same');
    % 根据式（3.15.9）用迭代法求解光流矢量
    u= uAvg - ( fx .* ( ( fx .* uAvg ) + ( fy .* vAvg ) + ft ) ) ./ ( alpha^2 + fx.^2 + fy.^2); 
    v= vAvg - ( fy .* ( ( fx .* uAvg ) + ( fy .* vAvg ) + ft ) ) ./ ( alpha^2 + fx.^2 + fy.^2);
end
u(isnan(u))=0;
v(isnan(v))=0;
% 画图
if displayFlow==1
   plotFlow(u, v, displayImg, 5, 5);  % 调用画图函数
end
