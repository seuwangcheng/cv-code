function resizeImageFig(h, sz, frac)
% function resizeImageFig(h, sz, frac)
% ���ܣ����ݾ���ػ�ͼ��Ĵ�С
%  sz = ͼ��ߴ�.
%  frac (Ĭ��ֵ= 1).
 
if (nargin <3)
 frac = 1;
end
 
pos = get(h, 'Position');
set(h, 'Units', 'pixels', 'Position', ...
       [pos(1), pos(2)+pos(4)-frac*sz(1), ...
        frac*sz(2), frac*sz(1)]);
set(gca,'Position', [0 0 1 1], 'Visible', 'off');
