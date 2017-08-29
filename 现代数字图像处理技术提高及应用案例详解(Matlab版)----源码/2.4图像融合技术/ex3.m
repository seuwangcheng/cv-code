LLa=y1(1:r/(2^dim),1:c/(2^dim));    
LLb=y2(1:r/(2^dim),1:c/(2^dim));
% 调用lowfrefus函数对低频部分的小波分解系数进行融合
y3(1:r/(2^dim),1:c/(2^dim))=lowfrefus(LLa,LLb);
