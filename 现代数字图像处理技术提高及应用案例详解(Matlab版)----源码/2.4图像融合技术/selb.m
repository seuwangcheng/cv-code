function Y = selb(M1, M2, mp)
% ���ܣ��Ի���ͼ��ѡ��ϵ��
% ���룺
%    M1  - ϵ��A
%    M2  - ϵ��B
%    mp  - ����ѡ��
%          mp == 1: ѡ��A
%          mp == 2: ѡ��B
%          mp == 3: ѡ��A��B�ľ�ֵ
%�����
%    Y   - �ں�ϵ��
 
switch (mp)
  case 1, Y = M1;
  case 2, Y = M2;
  case 3, Y = (M1 + M2) / 2;
  otherwise, error('unknown option');
end;
