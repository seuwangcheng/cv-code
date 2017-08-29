clear,clc
% 计算背景图像
Imzero = zeros(240,320,3);
for i = 1:5
Im{i} = double(imread(['DATA/',int2str(i),'.jpg']));
Imzero = Im{i}+Imzero;
end
Imback = Imzero/5;
[MR,MC,Dim] = size(Imback);
% Kalman滤波器初始化
R=[[0.2845,0.0045]',[0.0045,0.0455]'];
H=[[1,0]',[0,1]',[0,0]',[0,0]'];
Q=0.01*eye(4);
P = 100*eye(4);
dt=1;
A=[[1,0,0,0]',[0,1,0,0]',[dt,0,1,0]',[0,dt,0,1]'];
g = 6; 
Bu = [0,0,0,g]';
kfinit=0;
x=zeros(100,4);
% 循环遍历所有图像
for i = 1 : 60
  % 导入图像
  Im = (imread(['DATA/',int2str(i), '.jpg'])); 
  imshow(Im)
  imshow(Im)
  Imwork = double(Im);
  %提取球的质心坐标及半径
  [cc(i),cr(i),radius,flag] = extractball(Imwork,Imback,i);
  if flag==0
    continue
  end
  %用绿色标出球实际运动的位置
hold on
    for c = -1*radius: radius/20 : 1*radius
      r = sqrt(radius^2-c^2);
      plot(cc(i)+c,cr(i)+r,'g.')
      plot(cc(i)+c,cr(i)-r,'g.')
end
  % Kalman器更新
  if kfinit==0
    xp = [MC/2,MR/2,0,0]'
  else
    xp=A*x(i-1,:)' + Bu
  end
  kfinit=1;
  PP = A*P*A' + Q
  K = PP*H'*inv(H*PP*H'+R)
  x(i,:) = (xp + K*([cc(i),cr(i)]' - H*xp))';
  x(i,:)
  [cc(i),cr(i)]
  P = (eye(4)-K*H)*PP
%用红色画出球实际的运动位置
  hold on
    for c = -1*radius: radius/20 : 1*radius
      r = sqrt(radius^2-c^2);
      plot(x(i,1)+c,x(i,2)+r,'r.')
      plot(x(i,1)+c,x(i,2)-r,'r.')
    end
      pause(0.3)
end
% 画出球横纵坐标的位置
  figure
  plot(cc,'r*')
  hold on
  plot(cr,'g*')
%噪声估计
  posn = [cc(55:60)',cr(55:60)'];
  mp = mean(posn);
  diffp = posn - ones(6,1)*mp;
Rnew = (diffp'*diffp)/5;
