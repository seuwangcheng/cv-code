%function info = track(sour,savesour)
% function 
%   �ļ���    ��color_example
%   ����ʱ��  ��2006.11.5
%   ����      �� pineapple
%   ʵ�ֹ���  ���ڲ�ɫͼ�������У����Զ��ظ����˹�ѡ���Ķ���
%   
%   �ڴ˺����У�û�и���Ŀ��ģ�ͣ�����һֱ�����ʼѡ�е�Ŀ�ꡣpre_hist
%   �Զ�����Ŀ���С����color_object_tracking1�������Σ�������õĽ��
%

I = aviread('shaky_car.avi');      %   ����avi�ļ�
[M N_frame]=size(I);
previous_frame = I(1,1).cdata; % �����һ֡��Ϊ��ǰ֡
record_width = [];  % ��¼Ŀ��Ĵ�С�仯
record_cpoint = []; % ��¼Ŀ���λ�ñ仯
imshow(previous_frame);
rect = getrect();
x1 = rect(2); x2 = rect(2) + rect(4);
y1 = rect(1); y2 = rect(1) + rect(3);
target.width =[round((x2-x1)/2),round((y2-y1)/2)]; % ����Ŀ��Ĵ�С
target.cpoint = [round((x2+x1)/2),round((y2+y1)/2)]; % ����Ŀ�������λ��

record_width  = [record_width;target.width];
record_cpoint = [record_cpoint;target.cpoint];
%*********�ض���Ŀ��******************
   %  pre_cpoint = [168 102];
   % width      = [17 13];
%************************************
    temp_width  = zeros(3,2);
    temp_result = zeros(1,3);
kmatrix = compute_kernelmatrix(target.width,'guass');% �ɸ����Ĵ�С��������˾���
[pre_khist,pre_target_hist] = compute_k_hist(previous_frame,target,kmatrix);

target.k_hist = pre_khist;
fprintf('image_index=%d, cur_cpoint(1) = %d ,cur_cpoint(2) = %d\n',1,target.cpoint(1),target.cpoint(2));
show_target(previous_frame,target);  % �����ĺʹ�Сȷ����Ŀ�꣬����ʾ  
F = getframe;
mkdir('result');
image_source=strcat('result\','1.jpg');
imwrite(F.cdata,image_source);   

for image_index = 2:N_frame
    pre_width = target.width;
    current_frame = I(1,image_index).cdata;   %���뵱ǰ֡
    %   �ڵ�ǰ֡���ҵ���ǰ֡�е�Ŀ��
    [newtarget,resultinfo] = object_tracking(current_frame,target);
    newtarget.k_hist = target.k_hist;
     
    show_target(current_frame,newtarget,'g');
    F = getframe;
    image_source=strcat('test2\',num2str((image_index-1)*2),'.jpg');
%%%%    imwrite(F.cdata,image_source);  
     
    %    ����ǰ֡���� ��ǰ֡���ҵ���Ŀ��                       
    [newtarget1,resultinfo] = object_tracking(previous_frame,newtarget);
    
    final_cpoint = newtarget.cpoint+ (target.cpoint-newtarget1.cpoint);% ��У���������
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
        kmatrix = compute_kernelmatrix(target.width,'guass');% �ɸ����Ĵ�С��������˾���
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
