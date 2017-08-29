function [fx, fy, ft] = computeDerivatives(im1, im2)

% ���ܣ�������ͼ��ο����ص������ֵ�����᷽���ƫ����
% ���룺
%     im1-����ͼ��1
%     im2-����ͼ��2
% �����
%     fx-�ο����ص�ĻҶ�ֵ��x�����ƫ����
%     fy-�ο����ص�ĻҶ�ֵ��y�����ƫ����
%     fz-�ο����ص�ĻҶ�ֵ��z�����ƫ����

if size(im2,1)==0
    im2=zeros(size(im1));
end
 
% ���ñ�׼ģ�����ʽ��3.15.5���е�ƫ����Ix, Iy, It
fx = conv2(im1,0.25* [-1 1; -1 1],'same') + conv2(im2, 0.25*[-1 1; -1 1],'same');
fy = conv2(im1, 0.25*[-1 -1; 1 1], 'same') + conv2(im2, 0.25*[-1 -1; 1 1], 'same');
ft = conv2(im1, 0.25*ones(2),'same') + conv2(im2, -0.25*ones(2),'same');
