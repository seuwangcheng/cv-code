function d = tracking(video)
% 功能：跟踪视频中的运动目标并显示
% 输入：video-待跟踪的视频
% 输出：d-差值图像序列

% 读入视频图像
if ischar(video)
    avi = aviread(video);
    pixels = double(cat(4,avi(1:2:end).cdata))/255;
    clear avi
else
    pixels = double(cat(4,video{1:2:end}))/255;
    clear video
end
% 将RGB图像转换成灰度图像
nFrames = size(pixels,4);
for f = 1:nFrames
   pixel(:,:,f) = (rgb2gray(pixels(:,:,:,f)));  
end
 [rows,cols]=size(pixel(:,:,1));
nrames=f;
% 将相邻两帧图像进行作差，并将差值图像转换为二值图像
for l = 2:nrames
d(:,:,l)=(abs(pixel(:,:,l)-pixel(:,:,l-1)));
k=d(:,:,l);
   bw(:,:,l) = im2bw(k, .2);
   bw1=bwlabel(bw(:,:,l));
   imshow(bw(:,:,l))
   hold on
% 标记运动物体的位置并显示
cou=1;
for h=1:rows
    for w=1:cols
     if(bw(h,w,l)>0.5)
      toplen = h;
           if (cou == 1)
            tpln=toplen;
         end
         cou=cou+1;
      break
     end
     end
end
disp(toplen);
coun=1;
for w=1:cols
    for h=1:rows
     if(bw(h,w,l)>0.5)
        
      leftsi = w;
     if (coun == 1)
            lftln=leftsi;
            coun=coun+1;
   end
      break
     end
    end
end
disp(leftsi);
disp(lftln);   
widh=leftsi-lftln;
heig=toplen-tpln;
widt=widh/2;
disp(widt);
heit=heig/2;
with=lftln+widt;
heth=tpln+heit;
wth(l)=with;
hth(l)=heth;
 
disp(heit);
disp(widh);
disp(heig);
rectangle('Position',[lftln tpln widh heig],'EdgeColor','r');
disp(with);
disp(heth);
plot(with,heth, 'r*');
drawnow;
hold off
end
