function Y = selc(M1, M2, ap)
%���ܣ�ѡ���ͨ�˲���ϵ��
%���룺M1  - ϵ��A      M2  - ϵ��B    mp  - ����ѡ������1��2��3��4��
%�����Y   - �ں�ϵ��
% ���������ͼ���С�Ƿ���ͬ
[z1 s1] = size(M1);
[z2 s2] = size(M2);
if (z1 ~= z2) | (s1 ~= s2)
  error('Input images are not of same size');
end;
% ����ѡ��
switch(ap(1))
    case 1, 
    mm = (abs(M1)) > (abs(M2));
    Y  = (mm.*M1) + ((~mm).*M2);
    case 2,
    um = ap(2); th = .75;
    S1 = conv2(es2(M1.*M1, floor(um/2)), ones(um), 'valid'); 
    S2 = conv2(es2(M2.*M2, floor(um/2)), ones(um), 'valid'); 
    MA = conv2(es2(M1.*M2, floor(um/2)), ones(um), 'valid');
    MA = 2 * MA ./ (S1 + S2 + eps);
    m1 = MA > th; m2 = S1 > S2; 
    w1 = (0.5 - 0.5*(1-MA) / (1-th));
    Y  = (~m1) .* ((m2.*M1) + ((~m2).*M2));
    Y  = Y + (m1 .* ((m2.*M1.*(1-w1))+((m2).*M2.*w1) + ((~m2).*M2.*(1-w1))+((~m2).*M1.*w1)));
  case 3,          
        um = ap(2);
    A1 = ordfilt2(abs(es2(M1, floor(um/2))), um*um, ones(um));
    A2 = ordfilt2(abs(es2(M2, floor(um/2))), um*um, ones(um));
    mm = (conv2((A1 > A2), ones(um), 'valid')) > floor(um*um/2);
    Y  = (mm.*M1) + ((~mm).*M2);
 case 4, 
   mm = M1 > M2;
    Y  = (mm.*M1) + ((~mm).*M2);
  otherwise,
    error('unkown option');
end;  
