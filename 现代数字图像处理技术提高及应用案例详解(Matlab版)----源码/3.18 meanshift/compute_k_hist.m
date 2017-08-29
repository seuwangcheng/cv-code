function [k_hist,target_hist,khist] = compute_k_hist(frame,target,kmatrix,MM)
%   �������ļ���    ��  color_compute_k_hist
%	�汾           ��  1.0
%	����ʱ��       ��  2007.5.30
%   ����           ��  pineapple
%   ʵ�ֹ���       ��  �����ɫͼ���ֱ��ͼ���ͻҶ�ͼһ����ֻ�Ǽ���=mm*mm*mm	              
%    ���룺
%          frame : ��ǰ֡
%          target     ��  ѡ����Ŀ������
%          kmatrix   ��  �˾���
%          MM   : ��������
%    �����
%         target_hist  ��  Ŀ��target��mm��ֱ��ͼ����
%         k_hist       ��  Ŀ��target�ĺ�ֱ��ͼ
%         khist �� �ֿ����С��ĸ��Եĺ�ֱ��ͼ��
%	
%   ע�⣺
%       Ϊ�˺ͷֿ��⹦������ϣ������Ŀ��ֳ��Ŀ�ֱ������ֲ���
%   khist��һ���ṹ��
%   **********************************************************************
%       
[m , n , k] = size(frame);
if(k==3)
    if nargin < 4
        mmr = 8;  mmg = 8;  mmb = 8; 
    end
    yyyy=mmr*mmg*mmb;
    khist.up = zeros(1,yyyy);       %��
    khist.right = zeros(1,yyyy);    %
    khist.left = zeros(1,yyyy);     %
    khist.down = zeros(1,yyyy);     %
    
    parts_k_hist = zeros(9,mmr*mmg*mmb);
    
    cpoint = target.cpoint;
    width  = target.width;

    k_hist = zeros(1,yyyy);
    target_image = frame(cpoint(1)-width(1):cpoint(1)+width(1),cpoint(2)-width(2):cpoint(2)+width(2),:); 
    [m,n,k] = size(target_image);
    target_hist = zeros(m,n);
    target_image = double(target_image);
    parts_index = [1 (m-1)/2   1    (n-1)/2; %���� 1
                   1 (m-1)/2 (n+3)/2      n; %���� 2 
                 (m+3)/2    m   (n+3)/2      n; %���� 3 
                (m+3)/2    m     1    (n-1)/2; %���� 4 
                (m+1)/2 (m+1)/2  1    (n-1)/2; % �м��У����� 5
                (m+1)/2 (m+1)/2  (n+3)/2  n;   % �м��У����� 6
                
                1 (m-1)/2   (n+1)/2  (n+1)/2 ; % �м��У����� 7
                (m+3)/2  m  (n+1)/2  (n+1)/2 ; % �м��У����� 8
                
                (m+1)/2 (m+1)/2  (n+1)/2  (n+1)/2] ; % �м��У����� 9
for k = 1 : 9
    for i = parts_index(k,1) :parts_index(k,2)
        for j = parts_index(k,3) :parts_index(k,4)
            temp_1 = 1 + fix(target_image(i,j,1)*mmr/256);
            temp_2 = 1 + fix(target_image(i,j,2)*mmg/256);
            temp_3 = 1 + fix(target_image(i,j,3)*mmb/256);
            value = (temp_1-1)*mmg*mmb+(temp_2-1)*mmb+temp_3; 
            target_hist(i,j) = value;
            parts_k_hist(k,value) = parts_k_hist(k,value) + kmatrix(i,j);
            k_hist(1,value) = k_hist(1,value) + kmatrix(i,j);
        end
    end
end
    %   ��һ��
    k_hist = k_hist./(sum(k_hist)); 

    khist.rigth = parts_k_hist(2,:) + parts_k_hist(3,:) + parts_k_hist(7,:)+ parts_k_hist(8,:)+ parts_k_hist(9,:)+ parts_k_hist(6,:);
    khist.left =  parts_k_hist(1,:) + parts_k_hist(4,:) + parts_k_hist(7,:)+ parts_k_hist(8,:)+ parts_k_hist(9,:)+ parts_k_hist(5,:);
    khist.up =    parts_k_hist(1,:) + parts_k_hist(2,:) + parts_k_hist(5,:)+ parts_k_hist(6,:)+ parts_k_hist(9,:)+ parts_k_hist(7,:);
    khist.down =  parts_k_hist(3,:) + parts_k_hist(4,:) + parts_k_hist(5,:)+ parts_k_hist(6,:)+ parts_k_hist(9,:)+ parts_k_hist(8,:);
    
    khist.rigth = khist.rigth./(sum(khist.rigth));
    khist.left = khist.left./(sum(khist.left));
    khist.up = khist.up./(sum(khist.up));
    khist.down = khist.down./(sum(khist.down));
end

% cpoint = target.cpoint;
% width  = target.width;
%     k_hist1 = zeros(1,mmr*mmg*mmb);
%     target = frame(cpoint(1)-width(1):cpoint(1)+width(1),cpoint(2)-width(2):cpoint(2)+width(2),:); 
%     [m,n,k] = size(target);
%     target_hist1 = zeros(m,n);
%     target_image = double(target);
%     for i =1:m,
%         for j=1:n
%                 temp_1 = 1 + fix(target_image(i,j,1)*mmr/256);
%                 temp_2 = 1 + fix(target_image(i,j,2)*mmg/256);
%                 temp_3 = 1 + fix(target_image(i,j,3)*mmb/256);
%                 value = (temp_1-1)*mmg*mmb+(temp_2-1)*mmb+temp_3; 
%                 target_hist1(i,j) = value;
%                 k_hist1(1,value) = k_hist1(1,value) + kmatrix(i,j);
%             end
%     end
%     sum(k_hist1)
%     sum(kmatrix(:))
%     k_hist - k_hist1
%     target_hist1 - target_hist