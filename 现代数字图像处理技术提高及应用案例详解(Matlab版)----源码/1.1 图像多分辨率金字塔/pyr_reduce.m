function [ imgout ] = pyr_reduce( img )
% ���ܣ�����ͼ��ĸ�˹������
% ���룺img-�Ҷ�ͼ��
% �����imgout-�ֽ��Ľ�����ͼ������

% ���ɸ�˹��
kernelWidth = 5; 
cw = .375; 
ker1d = [.25-cw/2 .25 cw .25 .25-cw/2];
kernel = kron(ker1d,ker1d');
 
img = im2double(img);
sz = size(img);
imgout = [];
 
% ����ͼ��ĸ�˹������
for p = 1:size(img,3)
    img1 = img(:,:,p);
    imgFiltered = imfilter(img1,kernel,'replicate','same');
    imgout(:,:,p) = imgFiltered(1:2:sz(1),1:2:sz(2));
end
 
end
