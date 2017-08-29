function [row,col,max_local] = findLocalMaximum(val,radius)
    % ���ܣ��������򼫴�ֵ 
    % ���룺
    % val -NxM ����
    % radius �C����뾶��
    % �����
    % row �C���򼫴�ֵ�������ꣻ
    % col �C ���򼫴�ֵ�������ꣻ
    % max_local-���򼫴�ֵ��
  
    mask  = fspecial('disk',radius)>0;
    nb    = sum(mask(:));
    highest          = ordfilt2(val, nb, mask);
    second_highest   = ordfilt2(val, nb-1, mask);
    index            = highest==val & highest~=second_highest;
    max_local        = zeros(size(val));
    max_local(index) = val(index);
    [row,col]        = find(index==1);
 
end
