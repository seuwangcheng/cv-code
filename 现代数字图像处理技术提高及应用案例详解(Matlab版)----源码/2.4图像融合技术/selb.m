function Y = selb(M1, M2, mp)
% 功能：对基本图像选择系数
% 输入：
%    M1  - 系数A
%    M2  - 系数B
%    mp  - 类型选择
%          mp == 1: 选择A
%          mp == 2: 选择B
%          mp == 3: 选择A和B的均值
%输出：
%    Y   - 融合系数
 
switch (mp)
  case 1, Y = M1;
  case 2, Y = M2;
  case 3, Y = (M1 + M2) / 2;
  otherwise, error('unknown option');
end;
