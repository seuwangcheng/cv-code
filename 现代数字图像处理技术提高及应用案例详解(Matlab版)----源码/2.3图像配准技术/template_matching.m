function [I_SSD,I_NCC]=template_matching(T,I)
% 功能：图像配准
% [I_SSD,I_NCC]=template_matching(T,I)
% 输入： T-模板          I-输入的原始图像
% I_SSD-采用像素差平方和法（SSD）的匹配结果
% I_NCC-采用标准化互相关匹配法（NCC）的匹配结果

% 将图像转换成双精度型
T=double(T); I=double(I);
if(size(T,3)==3)
    % 如果是彩色图像，则按彩色图像匹配方法进行匹配
    [I_SSD,I_NCC]=template_matching_color(T,I);
else
    % 如果是灰度图像，则按灰度图像匹配方法进行匹配
    [I_SSD,I_NCC]=template_matching_gray(T,I);
end
function [I_SSD,I_NCC]=template_matching_color(T,I)
% 功能：对彩色图像进行匹配子函数，其核心原理是从R、G、B三个子色调进行匹配
[I_SSD_R,I_NCC_R]=template_matching_gray(T(:,:,1),I(:,:,1));
[I_SSD_G,I_NCC_G]=template_matching_gray(T(:,:,2),I(:,:,2));
[I_SSD_B,I_NCC_B]=template_matching_gray(T(:,:,3),I(:,:,3));
% 融合三次匹配结果
I_SSD=(I_SSD_R+I_SSD_G+I_SSD_B)/3;
I_NCC=(I_NCC_R+I_NCC_G+I_NCC_B)/3;
function [I_SSD,I_NCC]=template_matching_gray(T,I)
% 功能：对灰度图像进行匹配子函数
T_size = size(T); I_size = size(I);
outsize = I_size + T_size-1;
% 在频域内进行相关运算
if(length(T_size)==2)
    FT = fft2(rot90(T,2),outsize(1),outsize(2));
    FI = fft2(I,outsize(1),outsize(2));
    Icorr = real(ifft2(FI.* FT));
else
    FT = fftn(rot90_3D(T),outsize);
    FI = fftn(I,outsize);
    Icorr = real(ifftn(FI.* FT));
end
LocalQSumI= local_sum(I.*I,T_size);
QSumT = sum(T(:).^2);
% 计算模板和图像的像素差平方和
I_SSD=LocalQSumI+QSumT-2*Icorr;
% 将其皈依化到0和1之间
I_SSD=I_SSD-min(I_SSD(:));
I_SSD=1-(I_SSD./max(I_SSD(:)));
I_SSD=unpadarray(I_SSD,size(I));
if (nargout>1)
        LocalSumI= local_sum(I,T_size);
    stdI=sqrt(max(LocalQSumI-(LocalSumI.^2)/numel(T),0) );
    stdT=sqrt(numel(T)-1)*std(T(:));
    meanIT=LocalSumI*sum(T(:))/numel(T);
    I_NCC= 0.5+(Icorr-meanIT)./ (2*stdT*max(stdI,stdT/1e5));
    I_NCC=unpadarray(I_NCC,size(I));
end
function T=rot90_3D(T)
T=flipdim(flipdim(flipdim(T,1),2),3);
function B=unpadarray(A,Bsize)
Bstart=ceil((size(A)-Bsize)/2)+1;
Bend=Bstart+Bsize-1;
if(ndims(A)==2)
    B=A(Bstart(1):Bend(1),Bstart(2):Bend(2));
elseif(ndims(A)==3)
    B=A(Bstart(1):Bend(1),Bstart(2):Bend(2),Bstart(3):Bend(3));
end
function local_sum_I= local_sum(I,T_size)
B = padarray(I,T_size);
if(length(T_size)==2)
    s = cumsum(B,1);
    c = s(1+T_size(1):end-1,:)-s(1:end-T_size(1)-1,:);
    s = cumsum(c,2);
    local_sum_I= s(:,1+T_size(2):end-1)-s(:,1:end-T_size(2)-1);
else
    s = cumsum(B,1);
    c = s(1+T_size(1):end-1,:,:)-s(1:end-T_size(1)-1,:,:);
    s = cumsum(c,2);
    c = s(:,1+T_size(2):end-1,:)-s(:,1:end-T_size(2)-1,:);
    s = cumsum(c,3);
    local_sum_I  = s(:,:,1+T_size(3):end-1)-s(:,:,1:end-T_size(3)-1);
end
