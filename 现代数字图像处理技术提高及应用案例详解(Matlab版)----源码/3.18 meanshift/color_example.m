% function 
%   �ļ���    ��color_example
%   ����ʱ��  ��2006.11.5
%   ����      �� pineapple
%   ʵ�ֹ���  ���ڲ�ɫͼ�������У����Զ��ظ����˹�ѡ���Ķ���
%   
%   �ڴ˺����У�û�и���Ŀ��ģ�ͣ�����һֱ�����ʼѡ�е�Ŀ�ꡣpre_hist
%   �Զ�����Ŀ���С����color_object_tracking1�������Σ�������õĽ��
%
sour = 'F:\���Ѹ�\avi\';
sour = strcat(sour,'Browse_WhileWaiting1.avi');
I = aviread(sour);
[M N_frame]=size(I);
previous_frame = I(1,2).cdata; % �����һ֡��Ϊ��ǰ֡
imshow(previous_frame);
rect = getrect();
x1 = rect(2); x2 = rect(2) + rect(4);
y1 = rect(1); y2 = rect(1) + rect(3);
width =[round((x2-x1)/2),round((y2-y1)/2)];     % ����Ŀ��Ĵ�С
cpoint = [round((x2+x1)/2),round((y2+y1)/2)];   % ����Ŀ�������λ��
%*********�ض���Ŀ��******************
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
kmatrix = compute_kernelmatrix(pre_width,'guass',sqrt(sum(width.^2)));% �ɸ����Ĵ�С��������˾���
[pre_k_hist,pre_target_hist] = color_compute_k_hist(previous_frame,pre_cpoint,pre_width,kmatrix);
fprintf('image_index=%d, cur_cpoint(1) = %d ,cur_cpoint(2) = %d\n',1,pre_cpoint(1),pre_cpoint(2));
show_target(previous_frame,pre_cpoint,pre_width);  % �����ĺʹ�Сȷ����Ŀ�꣬����ʾ  
F = getframe;
image_source=strcat('test2\','1.jpg');
imwrite(F.cdata,image_source);    
for image_index = 3:N_frame
    current_frame = I(1,image_index).cdata;   %���뵱ǰ֡
    %   �ڵ�ǰ֡���ҵ���ǰ֡�е�Ŀ��
    [cur_cpoint,cur_width,cur_k_hist,temp_result] = ...
        color_object_tracking1(pre_k_hist,current_frame,pre_cpoint,pre_width);
    %///////////////////////////
        show_target(current_frame,cur_cpoint,pre_width);
        F = getframe;
        image_source=strcat('test2\',num2str((image_index-1)*2),'.jpg');
        imwrite(F.cdata,image_source);  
    %///////////////////////////
    %   �õ�ǰ֡���ҵ���Ŀ������ǰ֡���ҵ�Ŀ��                          
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
