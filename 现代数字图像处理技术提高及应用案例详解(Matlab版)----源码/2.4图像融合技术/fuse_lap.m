function Y = fuse_lap(M1, M2, zt, ap, mp)
% ���ܣ�����������˹������������������Ҷ�ͼ������ں�
% ���룺M1 �C ����ĻҶ�ͼ��A        M2 �C ����ĻҶ�ͼ��B
%    zt �C ���ֽ����              ap �C ��ͨ�˲���ϵ��ѡ�� (�� selc.m) 
%    mp �C ����ͼ��ϵ��ѡ�� (�� selb.m) 
%�����%    Y  - �ںϺ��ͼ��  
% ���������ͼ���С�Ƿ���ͬ
[z1 s1] = size(M1);
[z2 s2] = size(M2);
if (z1 ~= z2) | (s1 ~= s2)
  error('Input images are not of same size');
end;
% �����˲��� 
w  = [1 4 6 4 1] / 16;
E = cell(1,zt);
for i1 = 1:zt 
% ���㲢�洢ʵ��ͼ��ߴ�
    [z s]  = size(M1); 
  zl(i1) = z; sl(i1)  = s;
  % ����ͼ���Ƿ���Ҫ��չ
  if (floor(z/2) ~= z/2), ew(1) = 1; else, ew(1) = 0; end;
  if (floor(s/2) ~= s/2), ew(2) = 1; else, ew(2) = 0; end;
  % �����Ҫ��չ�Ļ���ͼ�������չ
  if (any(ew))
    M1 = adb(M1,ew);
    M2 = adb(M2,ew);
  end;  
  % �����˲� 
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
