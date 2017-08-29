function bw=adaptivethreshold(IM,ws,C,tm)
%   ���ܣ�����Ӧͼ��ָ�
%   ���룺
%	IM-���ָ��ԭʼͼ��
%	ws-ƽ���˲�ʱ�Ĵ��ڴ�С���ɲο�fspecial���÷�
%	C-��������Ҫ���ݾ���ѡȡ���ʵĲ���
%	tm-���ر�����tm=1������ֵ�˲���tm=0����о�ֵ�˲�
%	bw-ͼ��ָ������Ķ�ֵͼ��

% �����������
if (nargin<3)
    error('You must provide the image IM, the window size ws, and C.');
elseif (nargin==3)
    tm=0;
elseif (tm~=0 && tm~=1)
    error('tm must be 0 or 1.');
end
IM=mat2gray(IM);
if tm==0
% ͼ���ֵ�˲�
    mIM=imfilter(IM,fspecial('average',ws),'replicate');
else
% ͼ����ֵ�˲�
mIM=medfilt2(IM,[ws ws]);
end
sIM=mIM-IM-C;
bw=im2bw(sIM,0);
bw=imcomplement(bw);
