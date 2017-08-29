function show_targe(frame,target,color)
%%-------------------------------------------------------------------------------
%	函数名和文件名	：	show_target1
%	版本号		：	1.0
%	创建时间	：	2006.05.15
%	作者		:	pineapple
%	实现功能 	：      根据目标，目标中心cpoint，目标大小width显示目标
%	输入：
%	    cpoint	： 目标中心
%	    width	:  目标大小
%	说明：
%		对彩色图像和灰度图像都适用
%%-------------------------------------------------------------------------------
%右上点坐标 (cpoint(1)-width(1),cpoint(2)+width(2)
%左上点坐标 (cpoint(1)-width(1),cpoint(2)-width(2)

%左下点坐标 (cpoint(1)+width(1),cpoint(2)-width(2)
%右下点坐标 (cpoint(1)+width(1),cpoint(2)+width(2)
if nargin < 3
    color = 'r';
end
cpoint = target.cpoint;
width = target.width;
[M N K] =size(frame);%[行 列 维数]
left_x = max(cpoint(1)-width(1),1);  %左上点x坐标
left_y = max(cpoint(2)-width(2),1);  %左上点y坐标
right_x = min(cpoint(1)+width(1),M);%右下点x坐标
right_y = min(cpoint(2)+width(2),N); %右下点x坐标
imshow(frame);
hold on
 plot([left_y right_y],[left_x left_x],color,'LineWidth',2);%上
 plot([right_y right_y],[left_x right_x],color,'LineWidth',2);%右
 plot([left_y right_y],[right_x right_x],color,'LineWidth',2);%下
 plot([left_y left_y],[right_x left_x],color,'LineWidth',2);%上
hold off