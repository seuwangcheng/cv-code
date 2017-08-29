function Y = fuse_lap(M1, M2, zt, ap, mp)
% 功能：基于拉普拉斯金字塔对输入的两幅灰度图像进行融合
% 输入：M1 – 输入的灰度图像A        M2 – 输入的灰度图像B
%    zt – 最大分解层数              ap – 高通滤波器系数选择 (见 selc.m) 
%    mp – 基本图像系数选择 (见 selb.m) 
%输出：%    Y  - 融合后的图像  
% 检验输入的图像大小是否相同
[z1 s1] = size(M1);
[z2 s2] = size(M2);
if (z1 ~= z2) | (s1 ~= s2)
  error('Input images are not of same size');
end;
% 定义滤波器 
w  = [1 4 6 4 1] / 16;
E = cell(1,zt);
for i1 = 1:zt 
% 计算并存储实际图像尺寸
    [z s]  = size(M1); 
  zl(i1) = z; sl(i1)  = s;
  % 检验图像是否需要扩展
  if (floor(z/2) ~= z/2), ew(1) = 1; else, ew(1) = 0; end;
  if (floor(s/2) ~= s/2), ew(2) = 1; else, ew(2) = 0; end;
  % 如果需要扩展的话对图像进行扩展
  if (any(ew))
    M1 = adb(M1,ew);
    M2 = adb(M2,ew);
  end;  
  % 进行滤波 
  G1 = conv2(conv2(es2(M1,2), w, 'valid'),w', 'valid');
  G2 = conv2(conv2(es2(M2,2), w, 'valid'),w', 'valid');
   M1T = conv2(conv2(es2(undec2(dec2(G1)), 2), 2*w, 'valid'),2*w', 'valid');
   M2T = conv2(conv2(es2(undec2(dec2(G2)), 2), 2*w, 'valid'),2*w', 'valid');
 E(i1) = {selc(M1-M1T, M2-M2T, ap)};
  M1 = dec2(G1);
  M2 = dec2(G2);
end;
 
M1 = selb(M1,M2,mp);
for i1 = zt:-1:1
  M1T = conv2(conv2(es2(undec2(M1), 2), 2*w, 'valid'), 2*w', 'valid');
  M1  = M1T + E{i1};
  M1    = M1(1:zl(i1),1:sl(i1));
end;
Y = M1;
