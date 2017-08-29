function [posr, posc]=Harris1(in_image,a)
% ���ܣ����ͼ���Harris�ǵ�
% ���룺in_image��������RGBͼ������
%       a���ǵ������Ӧ��ȡֵ��ΧΪ��0.04��0.06
% �����posr���������ǵ������������
%       posc���������ǵ������������

% ��RGBͼ��ת���ɻҶ�ͼ��
in_image=rgb2gray(in_image);        
% unit8��ת��Ϊ˫����double64��
ori_im=double(in_image); 
           
%%%%%%����ͼ����x��y ����������ݶ�%%%%%%
% x�����ݶ�����ģ��
fx = [-1 0 1];                       
% x�����˲�
Ix = filter2(fx,ori_im);               
% y�����ݶ�����
fy = [-1;0;1];                       
% y�����˲�
Iy = filter2(fy,ori_im);  
              
%%%%%%��������������ݶȳ˻�%%%%%%
Ix2 = Ix.^2;
Iy2 = Iy.^2;
Ixy = Ix.*Iy;

%%%%%%ʹ�ø�˹�������ݶȳ˻����м�Ȩ%%%%%%
% ����7*7�ĸ�˹��������sigma=2
h= fspecial('gaussian',[7 7],2);        
Ix2 = filter2(h,Ix2);
Iy2 = filter2(h,Iy2);
Ixy = filter2(h,Ixy);

%%%%%%����ÿ����Ԫ��Harris��Ӧֵ%%%%%%
[height,width]=size(ori_im);
R = zeros(height,width);                            
% ����(i,j)����Harris��Ӧֵ
for i = 1:height
    for j = 1:width
        M = [Ix2(i,j) Ixy(i,j);Ixy(i,j) Iy2(i,j)];             
        R(i,j) = det(M)-a*(trace(M))^2;          
    end
end

%%%%%%ȥ��С����ֵ��Harris��Ӧֵ%%%%%%
Rmax=max(max(R));
%  ��ֵ
t=0.01* Rmax;                               
for i = 1:height
for j = 1:width
if R(i,j)<t
  R(i,j) = 0;
  end
end
end

%%%%%%����3��3����Ǽ���ֵ����%%%%%%      
% ���зǼ������ƣ����ڴ�С3*3
corner_peaks=imregionalmax(R);          
countnum=sum(sum(corner_peaks));

%%%%%%��ʾ����ȡ��Harris�ǵ�%%%%%% 
% posr�����ڴ�������������
[posr, posc] = find(corner_peaks== 1);       
% posc�����ڴ�������������
figure
imshow(in_image)
hold on
for i = 1 : length(posr)
    plot(posc(i),posr(i),'r+');
end
