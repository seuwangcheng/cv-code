clear data
disp('input video');
% ������Ƶͼ��samplevideo.avi����ʾ
avi = aviread('ccbr1.avi');
video = {avi.cdata};
for a = 1:length(video)
    imagesc(video{a});
    axis image off
    drawnow;
end;
disp('output video');
% ����tracking()�������˶�Ŀ����и���
tracking(video);
