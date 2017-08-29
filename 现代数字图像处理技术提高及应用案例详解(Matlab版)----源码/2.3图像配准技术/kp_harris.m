function points = kp_harris(im)
    % 功能：检测图像的Harris角点
   
    im = double(im(:,:,1));
    sigma = 1.5;
    s_D = 0.7*sigma;
    x  = -round(3*s_D):round(3*s_D);
    dx = x .* exp(-x.*x/(2*s_D*s_D)) ./ (s_D*s_D*s_D*sqrt(2*pi));
    dy = dx';
    Ix = conv2(im, dx, 'same');
    Iy = conv2(im, dy, 'same');
    s_I = sigma;
    g = fspecial('gaussian',max(1,fix(6*s_I+1)), s_I);
    Ix2 = conv2(Ix.^2, g, 'same'); 
    Iy2 = conv2(Iy.^2, g, 'same');
    Ixy = conv2(Ix.*Iy, g, 'same');
    cim = (Ix2.*Iy2 - Ixy.^2)./(Ix2 + Iy2 + eps);               
    [r,c,max_local] = findLocalMaximum(cim,3*s_I);
    t = 0.6*max(max_local(:));
    [r,c] = find(max_local>=t);
    points = [r,c];
end
function [row,col,max_local] = findLocalMaximum(val,radius)
   
    mask  = fspecial('disk',radius)>0;
    nb    = sum(mask(:));
    highest          = ordfilt2(val, nb, mask);
    second_highest   = ordfilt2(val, nb-1, mask);
    index            = highest==val & highest~=second_highest;
    max_local        = zeros(size(val));
    max_local(index) = val(index);
    [row,col]        = find(index==1);
end
