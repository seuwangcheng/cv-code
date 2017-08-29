function [m2p,Ga,Gb] = area_var_match(A,B,p)
% 功能：计算两个输入矩阵以点p为中心的区域方差以及区域方差匹配度
% 设置区域的大小
level=1;    
[subA,mpa,npa]=submat(A,p,level);    
% submat 函数取输入矩阵中以点P为中心、阶数为（2*level+1）的方阵作为子矩阵
[subB,mpb,npb]=submat(B,p,level);
[r,c]=size(subA);
% 获取子矩阵的权值分布
w=weivec(subA,[mpa npa]);    
% 计算子矩阵的平均值
averA=sum(sum(subA))/(r*c); 
averB=sum(sum(subB))/(r*c);
% 计算子矩阵的区域方差
Ga=sum(sum(w.*(subA-averA).^2));    
Gb=sum(sum(w.*(subB-averB).^2));
% 计算两个子矩阵的区域方差匹配度
if (Ga==0)&(Gb==0)      
    m2p=0;
else
    m2p=2*sum(sum(w.*abs(subA-averA).*abs(subB-averB)))/(Ga+Gb);
end
