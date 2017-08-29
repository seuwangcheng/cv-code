function [cc,cr,radius,flag]=extractball(Imwork,Imback,index)
% 功能：提取图像中最大斑点的质心坐标及半径
% 输入：Imwork-输入的当前帧的图像；Imback-输入的背景图像；index-帧序列图像序号
% 输出：cc-质心行坐标；cr-质心列坐标；radius-斑点区域半径；flag-标志
  cc = 0;
  cr = 0;
  radius = 0;
  flag = 0;
  [MR,MC,Dim] = size(Imback);
  % 将输入图像与背景图像相减，获得差异最大的区域
  fore = zeros(MR,MC);          
  fore = (abs(Imwork(:,:,1)-Imback(:,:,1)) > 10) ...
     | (abs(Imwork(:,:,2) - Imback(:,:,2)) > 10) ...
     | (abs(Imwork(:,:,3) - Imback(:,:,3)) > 10);  
  foremm = bwmorph(fore,'erode',2); % 运用数学形态学去除微小的噪声
  % 选择大的斑点对其周围进行标记
  labeled = bwlabel(foremm,4);
  stats = regionprops(labeled,['basic']);
  [N,W] = size(stats);
  if N < 1
    return   
  end
 % 如果大的斑点的数量大于1，则用冒泡法进行排序
  id = zeros(N);
  for i = 1 : N
    id(i) = i;
  end
  for i = 1 : N-1
    for j = i+1 : N
      if stats(i).Area < stats(j).Area
        tmp = stats(i);
        stats(i) = stats(j);
        stats(j) = tmp;
        tmp = id(i);
        id(i) = id(j);
        id(j) = tmp;
      end
    end
  end
  % 确定并选取一个大的区域
  if stats(1).Area < 100 
    return
  end
  selected = (labeled==id(1));
  % 获得最大斑点区域的圆心及半径，并将标志置为1
  centroid = stats(1).Centroid;
  radius = sqrt(stats(1).Area/pi);
  cc = centroid(1);
  cr = centroid(2);
  flag = 1;
  return
