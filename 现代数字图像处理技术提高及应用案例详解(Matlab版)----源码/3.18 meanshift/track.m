%function info = track(sour,savesour)
% function 
%   文件名    ：color_example
%   创建时间  ：2006.11.5
%   作者      ： pineapple
%   实现功能  ：在彩色图像序列中，半自动地跟踪人工选定的对象。
%   
%   在此函数中，没有更改目标模型，即它一直是最初始选中的目标。pre_hist
%   自动调整目标大小。将color_object_tracking1调用三次，保留最好的结果
%

I = aviread('shaky_car.avi');      %   读入avi文件
[M N_frame]=size(I);
previous_frame = I(1,1).cdata; % 读入第一帧作为先前帧
record_width = [];  % 记录目标的大小变化
record_cpoint = []; % 记录目标的位置变化
imshow(previous_frame);
rect = getrect();
x1 = rect(2); x2 = rect(2) + rect(4);
y1 = rect(1); y2 = rect(1) + rect(3);
target.width =[round((x2-x1)/2),round((y2-y1)/2)]; % 跟踪目标的大小
target.cpoint = [round((x2+x1)/2),round((y2+y1)/2)]; % 跟踪目标的中心位置

record_width  = [record_width;target.width];
record_cpoint = [record_cpoint;target.cpoint];
%*********特定的目标******************
   %  pre_cpoint = [168 102];
   % width      = [17 13];
%************************************
    temp_width  = zeros(3,2);
    temp_result = zeros(1,3);
kmatrix = compute_kernelmatrix(target.width,'guass');% 由给定的大小，先算出核矩阵
[pre_khist,pre_target_hist] = compute_k_hist(previous_frame,target,kmatrix);

target.k_hist = pre_khist;
fprintf('image_index=%d, cur_cpoint(1) = %d ,cur_cpoint(2) = %d\n',1,target.cpoint(1),target.cpoint(2));
show_target(previous_frame,target);  % 由中心和大小确定该目标，并显示  
F = getframe;
mkdir('result');
image_source=strcat('result\','1.jpg');
imwrite(F.cdata,image_source);   

for image_index = 2:N_frame
    pre_width = target.width;
    current_frame = I(1,image_index).cdata;   %读入当前帧
    %   在当前帧中找到先前帧中的目标
    [newtarget,resultinfo] = object_tracking(current_frame,target);
    newtarget.k_hist = target.k_hist;
     
    show_target(current_frame,newtarget,'g');
    F = getframe;
    image_source=strcat('test2\',num2str((image_index-1)*2),'.jpg');
%%%%    imwrite(F.cdata,image_source);  
     
    %    在先前帧中找 当前帧中找到的目标                       
    [newtarget1,resultinfo] = object_tracking(previous_frame,newtarget);
    
    final_cpoint = newtarget.cpoint+ (target.cpoint-newtarget1.cpoint);% 经校正后的中心
    target.cpoint = final_cpoint;
    %-------------------------------
        show_target(current_frame,target);
        F = getframe(gca);
        image_source=strcat('test2\',num2str((image_index-1)*2+1),'.jpg');
 %%%%%% imwrite(F.cdata,image_source);
    %--------------------------------
    for i = 1 : 3
        target.width = round(pre_width*(0.8 + 0.1*i));
        temp_width(i,:) = target.width;
        kmatrix = compute_kernelmatrix(target.width,'guass');% 由给定的大小，先算出核矩阵
        [pre_khist,pre_target_hist] = compute_k_hist(current_frame,target,kmatrix);
        temp_result(i) = sum(pre_khist.*target.k_hist);
    end
    [k L] = max(temp_result)
   % pre_width = temp_width(L,:);
   target.width = round(0.1*pre_width +0.9*temp_width(L,:));
    record_width = [record_width;target.width];
    record_cpoint= [record_cpoint;target.cpoint];
    show_target(current_frame,target);
    
    previous_frame=current_frame;
    fprintf('image_index=%d,cur_cpoint(1 =%d ,cur_cpoint(2)=%d\n',image_index+1,target.cpoint(1),target.cpoint(2));
    %figure;

    %mov = addframe(mov,F);
end

% mov = close(mov);
