function smoothedImg=smoothImg(img,segma)
% ���ܣ�ʵ��ƽ����Լ������
% ���룺
%     img-����ͼ��
%     sigma-��˹�ֲ��ķ���
% �����
%     smoothedImg-����˹�˲���ͼ�����

if nargin<2
    segma=1;
end
%���ø�˹�˲�����
G=gaussFilter(segma);  
%���ݣ�3.15.7����ͼ�����ƽ��Լ��
smoothedImg=conv2(img,G,'same');  
% ����ƽ��
smoothedImg=conv2(smoothedImg,G','same');  
