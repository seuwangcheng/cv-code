clear data
disp('input video');
% 读入视频图像samplevideo.avi并显示
avi = aviread('ccbr1.avi');
video = {avi.cdata};
for a = 1:length(video)
    imagesc(video{a});
    axis image off
    drawnow;
end;
disp('output video');
% 调用tracking()函数对运动目标进行跟踪
tracking(video);
