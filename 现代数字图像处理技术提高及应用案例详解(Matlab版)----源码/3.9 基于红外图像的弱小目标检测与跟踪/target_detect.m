function P=target_detect(im,r)
% ����:����ͼ�����Ҷȸ��ʾ���
% ����:im-RGBͼ��        r-����뾶
% ���:P-����Ҷȸ��ʾ���

% P-ͼ��ת��
if size(size(im),2)==3
im=rgb2gray(im); 
end
[m,n]=size(im);
local_region=zeros(2*r+1,2*r+1); 
% ���������ʾ���
for i=r+1:m-r
  for j=r+1:n-r
    local_region=im(i-r:i+r,j-r:j+r);
    P(i,j)=im(i,j)/sum(sum(local_region));
  end
end
