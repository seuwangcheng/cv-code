function kmatrix = compute_kernelmatrix(width,method)
%  -----------------------------------------------------------------------------------
%  函数名和文件名：   compute_kernelmatrix
%  版本号：   2.0
%  创建时间：   2006.12.7
%  作者：   pineapple
%
%  实现功能：   
%          由给定的大小width计算核直方图，这里用到的核是(1 - x),Epanechnikov
%		   如果这里用高斯核来做，那么后面计算wi的时候，其形式也要跟着变了。
%  输入：
%       width：   即目标大小（2*width(1)+1,2*width(2)+1)
%       method:   决定核函数的类型,为简单起见，只设有两种选择：高斯核，Epanechnikov
%  输出：
%	    kmatrix：   2*n+1 * 2*m +1 的一个矩阵
%  注意：
%       这里是用带宽矩阵来代替单一半径参数
    if nargin< 2
        method = 'guass';
    end
    x_W = width(1);
    y_W = width(2);
    x_kmatrix = - x_W : x_W;
    y_kmatrix = - y_W : y_W;
    [X_kmatrix,Y_kmatrix] = meshgrid(y_kmatrix,x_kmatrix);
    % 引入带宽矩阵：
    kmatrix = (X_kmatrix/(width(1)+eps)).^2 + (Y_kmatrix/(width(2)+eps)).^2;
    switch method
    case 'guass'
            kmatrix = exp(-kmatrix./1);% h为核窗宽
    case 'flat'
            kmatrix = 1- kmatrix./2.1;  %因为这里kmatrix的最大值为2
    end    
    
    