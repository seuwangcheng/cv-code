function plotFlow(u, v, imgOriginal, rSize, scale)
% 功能：绘制光流场图
% 输入：u-横向光流矢量     v-纵向光流矢量     imgOriginal-光流场显示的图像
%     rSize-可见光流矢量区域的尺寸             scale-光流场规模
figure();
if nargin>2
    if sum(sum(imgOriginal))~=0
        imshow(imgOriginal,[0 255]);
        hold on;
    end
end
if nargin<4
    rSize=5;
end
if nargin<5
    scale=3;
end
for i=1:size(u,1)
    for j=1:size(u,2)
        if floor(i/rSize)~=i/rSize || floor(j/rSize)~=j/rSize
            u(i,j)=0;
            v(i,j)=0;
        end
    end
end
quiver(u, v, scale, 'color', 'b', 'linewidth', 2);
set(gca,'YDir','reverse');
