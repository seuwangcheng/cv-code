function draw2(img1,img2,pt1,pt2,result)  
% 功能：功能显示匹配特征点子程序
    h = figure;
    subplot(1,2,1);
    imshow(img1);
    subplot(1,2,2);
    imshow(img2);
    s = size(pt1,2);
    subplot(1,2,1);
    for i=1:size(pt1,1)       
       rectangle('Position',[pt1(i,2)-s,pt1(i,1)-s,2*s,2*s],'Curvature',[00],'EdgeColor','b','LineWidth',2);
    end
    subplot(1,2,2);
    for i=1:size(pt2,1)
       rectangle('Position',[pt2(i,2)-s,pt2(i,1)-s,2*s,2*s],'Curvature',[00],'EdgeColor','b','LineWidth',2);
    end
    for i=1:size(result,2)
        if(result(1,i)~=0)
            subplot(1,2,1);
            text(pt1(result(1,i),2)+3,pt1(result(1,i),1)+3,num2str(i),'BackgroundColor',[1 1 1]);
            subplot(1,2,2);
            text(pt2(i,2)+3,pt2(i,1)+3,num2str(i),'BackgroundColor',[1 1 1]);
        end
    end
end
