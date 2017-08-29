function y = lowfrefus(A,B);
% 功能：对输入的小波分解系数矩阵，根据融合算法，得出融合图像的低频小波分解系数
%求出分解系数矩阵的行列数
[row,col]=size(A);    
% alpha是方差匹配度比较的阈值
alpha=0.5;        
% 根据低频融合算法，先求出矩阵A,B中以点P为中心的区域方差和方差匹配度
for i=1:row        
for j=1:col        
% 再根据方差匹配度与阈值的比较确定融合图像的小波分解系数     
[m2p(i,j),Ga(i,j),Gb(i,j)] = area_var_match(A,B,[i,j]);
        Wmin=0.2-0.5*((1-m2p(i,j))/(1-alpha));
        Wmax=1-Wmin;
       % m2p表示方差匹配度
if m2p(i,j)<alpha        
            if Ga(i,j)>=Gb(i,j)        
% 若匹配度小于阈值，则取区域方差大的相应点的分解系数作为融合图像的分解系数
                y(i,j)=A(i,j);
            else
                y(i,j)=B(i,j);
            end
 % 若匹配度大于阈值，则采取加权平均方法得出相应的分解系数
else               
            if Ga(i,j)>=Gb(i,j)
                y(i,j)=Wmax*A(i,j)+Wmin*B(i,j);
            else
                y(i,j)=Wmin*A(i,j)+Wmax*B(i,j);
            end
        end
    end
end
