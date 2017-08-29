function[m1,m2,cormat] = matchbycorrelation(im1, p1, im2, p2, w, dmax)
% ����:�����������ͼ����׼
% ���룺im1-�Ҷ�ͼ��im1(��Ҫת����double��)        im2-�Ҷ�ͼ��im1(��Ҫת����double��)
%       p1-ͼ��im1�ϵ������㣨2��N����             p2-ͼ��im2�ϵ������㣨2��N����
%       w-���ڴ�С                                    damx-���ƥ��뾶
% �����m1-�Ҷ�ͼ��im1��ƥ��������                 m2-�Ҷ�ͼ��im1��ƥ��������
%       cormat-��ؾ���
if nargin == 5
    dmax = Inf;
end
im1 = double(im1);
im2 = double(im2);
im1 = im1 - filter2(fspecial('average',w),im1);
im2 = im2 - filter2(fspecial('average',w),im2);   
% ������ؾ���
cormat = correlatiomatrix(im1, p1, im2, p2, w, dmax);
[corrows,corcols] = size(cormat);
% ������ؾ����е����ֵ
[mp2forp1, colp2forp1] = max(cormat,[],2);
[mp1forp2, rowp1forp2] = max(cormat,[],1);   
p1ind = zeros(1,length(p1)); 
p2ind = zeros(1,length(p2));   
indcount = 0;   
for n = 1:corrows
    if rowp1forp2(colp2forp1(n)) == n  
        indcount = indcount + 1;
        p1ind(indcount) = n;
        p2ind(indcount) = colp2forp1(n);
    end
end
% ����ƥ�������
p1ind = p1ind(1:indcount);   
p2ind = p2ind(1:indcount);       
% ��ԭʼ��������ȡƥ�������
m1 = p1(:,p1ind); 
m2 = p2(:,p2ind); 
