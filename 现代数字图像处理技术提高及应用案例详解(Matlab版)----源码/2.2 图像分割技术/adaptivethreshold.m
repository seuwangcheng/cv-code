function bw=adaptivethreshold(IM,ws,C,tm)
%   功能：自适应图像分割
%   输入：
%	IM-待分割的原始图像
%	ws-平均滤波时的窗口大小，可参考fspecial的用法
%	C-常量，需要根据经验选取合适的参数
%	tm-开关变量，tm=1进行中值滤波，tm=0则进行均值滤波
%	bw-图像分割后输出的二值图像

% 输入参数处理
if (nargin<3)
    error('You must provide the image IM, the window size ws, and C.');
elseif (nargin==3)
    tm=0;
elseif (tm~=0 && tm~=1)
    error('tm must be 0 or 1.');
end
IM=mat2gray(IM);
if tm==0
% 图像均值滤波
    mIM=imfilter(IM,fspecial('average',ws),'replicate');
else
% 图像中值滤波
mIM=medfilt2(IM,[ws ws]);
end
sIM=mIM-IM-C;
bw=im2bw(sIM,0);
bw=imcomplement(bw);
