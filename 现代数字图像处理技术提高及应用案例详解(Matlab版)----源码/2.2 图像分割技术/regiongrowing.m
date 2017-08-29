function J=regiongrowing(I,x,y,reg_maxdist)
% 功能：基于区域生长法的图像分割
% 输入：I-待分割的输入图像               x,y-种子点的坐标 
%       t –最大密度距离(默认值为0.2)
% 输出：J-分割后的图像
% 示例:
% I = im2double(imread('medtest.png'));
% x=198; y=359;
% J = regiongrowing(I,x,y,0.2); 
% figure, imshow(I+J);
if(exist('reg_maxdist','var')==0), reg_maxdist=0.2; end
if(exist('y','var')==0), figure, imshow(I,[]); [y,x]=getpts; y=round(y(1)); x=round(x(1)); end
J = zeros(size(I)); 
Isizes = size(I); 
% 分割区域的均值
reg_mean = I(x,y); 
% 区域中的像素数
reg_size = 1; 
neg_free = 10000; neg_pos=0;
neg_list = zeros(neg_free,3); 
% 区域中新的像素距区域的距离
pixdist=0; 
neigb=[-1 0; 1 0; 0 -1;0 1];
% 基于区域生长的图像分割
while(pixdist<reg_maxdist&&reg_size<numel(I))
    % 添加新的邻域像素
    for j=1:4,
        % 计算邻域坐标
        xn = x +neigb(j,1); yn = y +neigb(j,2);
        % 检查邻域是否在图像内部
        ins=(xn>=1)&&(yn>=1)&&(xn<=Isizes(1))&&(yn<=Isizes(2));
        if(ins&&(J(xn,yn)==0)) 
                neg_pos = neg_pos+1;
                neg_list(neg_pos,:) = [xn yn I(xn,yn)]; J(xn,yn)=1;
        end
    end
    if(neg_pos+10>neg_free), neg_free=neg_free+10000; neg_list((neg_pos+1):neg_free,:)=0; end
    dist = abs(neg_list(1:neg_pos,3)-reg_mean);
    [pixdist, index] = min(dist);
    J(x,y)=2; reg_size=reg_size+1;
    % 计算区域新的均值
    reg_mean= (reg_mean*reg_size + neg_list(index,3))/(reg_size+1);
    x = neg_list(index,1); y = neg_list(index,2);
    neg_list(index,:)=neg_list(neg_pos,:); neg_pos=neg_pos-1;
end
J=J>1;
