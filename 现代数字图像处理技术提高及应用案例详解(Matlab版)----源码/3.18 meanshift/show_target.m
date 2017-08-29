function show_targe(frame,target,color)
%%-------------------------------------------------------------------------------
%	���������ļ���	��	show_target1
%	�汾��		��	1.0
%	����ʱ��	��	2006.05.15
%	����		:	pineapple
%	ʵ�ֹ��� 	��      ����Ŀ�꣬Ŀ������cpoint��Ŀ���Сwidth��ʾĿ��
%	���룺
%	    cpoint	�� Ŀ������
%	    width	:  Ŀ���С
%	˵����
%		�Բ�ɫͼ��ͻҶ�ͼ������
%%-------------------------------------------------------------------------------
%���ϵ����� (cpoint(1)-width(1),cpoint(2)+width(2)
%���ϵ����� (cpoint(1)-width(1),cpoint(2)-width(2)

%���µ����� (cpoint(1)+width(1),cpoint(2)-width(2)
%���µ����� (cpoint(1)+width(1),cpoint(2)+width(2)
if nargin < 3
    color = 'r';
end
cpoint = target.cpoint;
width = target.width;
[M N K] =size(frame);%[�� �� ά��]
left_x = max(cpoint(1)-width(1),1);  %���ϵ�x����
left_y = max(cpoint(2)-width(2),1);  %���ϵ�y����
right_x = min(cpoint(1)+width(1),M);%���µ�x����
right_y = min(cpoint(2)+width(2),N); %���µ�x����
imshow(frame);
hold on
 plot([left_y right_y],[left_x left_x],color,'LineWidth',2);%��
 plot([right_y right_y],[left_x right_x],color,'LineWidth',2);%��
 plot([left_y right_y],[right_x right_x],color,'LineWidth',2);%��
 plot([left_y left_y],[right_x left_x],color,'LineWidth',2);%��
hold off