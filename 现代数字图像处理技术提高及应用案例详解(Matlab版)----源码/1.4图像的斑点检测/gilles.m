function points = gilles(im,o_radius)
    % ���ܣ���ȡGilles�ߵ�
    % ���룺
    %      im �C�����ͼ��
    %      o_radius -�ߵ���뾶����ѡ��
    % �����
    %      points -�����İߵ�
    %
    % �ο����ף�
    % S. Gilles, Robust Description and Matching of Images. PhD thesis,
    % Oxford University, Ph.D. thesis, Oxford University, 1988.
   
    im = im(:,:,1);
 
    % ����
    if nargin==1
        radius = 10;
    else
        radius = o_radius;
end
% ������ģ(mask)����
    mask = fspecial('disk',radius)>0;
 
    % ������ģ����ľֲ���ֵ
    loc_ent = entropyfilt(im,mask);
 
    % Ѱ�Ҿֲ���ֵ
    [l,c,tmp] = findLocalMaximum(loc_ent,radius);
 
    % ������ֵ�İߵ�ȷ��Ϊ��Ҫ��ȡ�İߵ�
    [l,c]     = find(tmp>0.95*max(tmp(:)));
    points    = [l,c,repmat(radius,[size(l,1),1])];
 
end
