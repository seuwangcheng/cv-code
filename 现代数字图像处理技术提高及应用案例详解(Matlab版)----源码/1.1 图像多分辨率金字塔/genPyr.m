function [ pyr ] = genPyr( img, type, level )
%   ���ܣ� ����ͼ��ĸ�˹��������������˹������
%   ���룺img-�Ҷ�ͼ��
%         type-�任�����ͣ�'gauss' or 'laplace'��
%         level-�ֽ����
%   �����PYR-1*LEVEL Ԫ������

pyr = cell(1,level);
pyr{1} = im2double(img);
%%%%%%ͼ��Ľ�������%%%%%%

%����ͼ��ĸ�˹������
for p = 2:level
    pyr{p} = pyr_reduce(pyr{p-1});
end
if strcmp(type,'gauss'), return; end
 
% ����ͼ��ߴ�
for p = level-1:-1:1
    osz = size(pyr{p+1})*2-1;
    pyr{p} = pyr{p}(1:osz(1),1:osz(2),:);
end

% ����ͼ���������˹������
for p = 1:level-1
    pyr{p} = pyr{p}-pyr_expand(pyr{p+1});
end
 
end
