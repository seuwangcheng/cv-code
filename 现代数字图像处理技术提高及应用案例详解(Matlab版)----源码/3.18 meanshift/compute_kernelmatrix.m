function kmatrix = compute_kernelmatrix(width,method)
%  -----------------------------------------------------------------------------------
%  ���������ļ�����   compute_kernelmatrix
%  �汾�ţ�   2.0
%  ����ʱ�䣺   2006.12.7
%  ���ߣ�   pineapple
%
%  ʵ�ֹ��ܣ�   
%          �ɸ����Ĵ�Сwidth�����ֱ��ͼ�������õ��ĺ���(1 - x),Epanechnikov
%		   ��������ø�˹����������ô�������wi��ʱ������ʽҲҪ���ű��ˡ�
%  ���룺
%       width��   ��Ŀ���С��2*width(1)+1,2*width(2)+1)
%       method:   �����˺���������,Ϊ�������ֻ��������ѡ�񣺸�˹�ˣ�Epanechnikov
%  �����
%	    kmatrix��   2*n+1 * 2*m +1 ��һ������
%  ע�⣺
%       �������ô�����������浥һ�뾶����
    if nargin< 2
        method = 'guass';
    end
    x_W = width(1);
    y_W = width(2);
    x_kmatrix = - x_W : x_W;
    y_kmatrix = - y_W : y_W;
    [X_kmatrix,Y_kmatrix] = meshgrid(y_kmatrix,x_kmatrix);
    % ����������
    kmatrix = (X_kmatrix/(width(1)+eps)).^2 + (Y_kmatrix/(width(2)+eps)).^2;
    switch method
    case 'guass'
            kmatrix = exp(-kmatrix./1);% hΪ�˴���
    case 'flat'
            kmatrix = 1- kmatrix./2.1;  %��Ϊ����kmatrix�����ֵΪ2
    end    
    
    