% function 
%   文件名    ：color_example
%   创建时间  ：2006.11.5
%   作者      ： pineapple
%   实现功能  ：在彩色图像序列中，半自动地跟踪人工选定的对象。
%   
%   在此函数中，没有更改目标模型，即它一直是最初始选中的目标。pre_hist
%   自动调整目标大小。将color_object_tracking1调用三次，保留最好的结果
%
sour = 'F:\凡友福\avi\';
sour = strcat(sour,'Browse_WhileWaiting1.avi');
I = aviread(sour);
[M N_frame]=size(I);
previous_frame = I(1,2).cdata; % 读入第一帧作为先前帧
imshow(previous_frame);
rect = getrect();
x1 = rect(2); x2 = rect(2) + rect(4);
y1 = rect(1); y2 = rect(1) + rect(3);
width =[round((x2-x1)/2),round((y2-y1)/2)];     % 跟踪目标的大小
cpoint = [round((x2+x1)/2),round((y2+y1)/2)];   % 跟踪目标的中心位置
%*********特定的目标******************
%     pre_cpoint = [168 102];
%     width      = [17 13];
%************************************
pre_cpoint = cpoint;
pre_width  = width;
my_width = pre_width;
my_cpoint = pre_cpoint;
    temp_cpoint = zeros(3,2);
    temp_width  = zeros(3,2);
    temp_result = zeros(1,3);
kmatrix = compute_kernelmatrix(pre_width,'guass',sqrt(sum(width.^2)));% 由给定的大小，先算出核矩阵
[pre_k_hist,pre_target_hist] = color_compute_k_hist(previous_frame,pre_cpoint,pre_width,kmatrix);
fprintf('image_index=%d, cur_cpoint(1) = %d ,cur_cpoint(2) = %d\n',1,pre_cpoint(1),pre_cpoint(2));
show_target(previous_frame,pre_cpoint,pre_width);  % 由中心和大小确定该目标，并显示  
F = getframe;
image_source=strcat('test2\','1.jpg');
imwrite(F.cdata,image_source);    
for image_index = 3:N_frame
    current_frame = I(1,image_index).cdata;   %读入当前帧
    %   在当前帧中找到先前帧中的目标
    [cur_cpoint,cur_width,cur_k_hist,temp_result] = ...
        color_object_tracking1(pre_k_hist,current_frame,pre_cpoint,pre_width);
    %///////////////////////////
        show_target(current_frame,cur_cpoint,pre_width);
        F = getframe;
        image_source=strcat('test2\',num2str((image_index-1)*2),'.jpg');
        imwrite(F.cdata,image_source);  
    %///////////////////////////
    %   用当前帧中找到的目标在先前帧中找到目标                          
    [temp_cpoint,temp_width,cur_k_hist,temp_result] = ...
        color_object_tracking1(cur_k_hist,previous_frame,cur_cpoint,cur_width);
    final_cpoint = cur_cpoint+ (pre_cpoint-temp_cpoint);
    %///////////////////////////
        show_target(current_frame,final_cpoint,pre_width,3);
        F = getframe(gca);
        image_source=strcat('test2\',num2str((image_index-1)*2+1),'.jpg');
        imwrite(F.cdata,image_source);
    %//////////////////////////////
    previous_frame=current_frame;
    pre_cpoint = cur_cpoint;
    my_cpoint= [my_cpoint;pre_cpoint];
    fprintf('image_index=%d,cur_cpoint(1 =%d ,cur_cpoint(2)=%d\n',image_index+1,pre_cpoint(1),pre_cpoint(2));
    %figure;

    %mov = addframe(mov,F);
end

% mov = close(mov);
