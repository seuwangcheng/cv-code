function [ pos, scale, orient, desc ] = SIFT( im, octaves, intervals, object_mask, contrast_threshold, curvature_threshold, interactive )

% ���ܣ���ȡ�Ҷ�ͼ��ĳ߶Ȳ���������SIFT������
% ����:
% im - �Ҷ�ͼ�񣬸�ͼ��ĻҶ�ֵ��0��1֮�䣨ע�⣺Ӧ���ȶ�����ͼ��ĻҶ�ֵ���й�һ������
% octaves - ��������������octaves (Ĭ��ֵΪ4).  
% intervals - �������������ÿ��������Ĳ���(Ĭ��ֵΪ 2).
% object_mask - ȷ��ͼ���г߶Ȳ���������������������û���ر�ָ�������㷨����������ͼ��
% contrast_threshold - �Աȶ���ֵ(Ĭ��ֵΪ0.03).
% curvature_threshold - ������ֵ��Ĭ��ֵΪ10.0��.
% interactive - ����������ʾ��־�������趨Ϊ1,����ʾ�㷨����ʱ��͹��̵������Ϣ��
% ��������趨Ϊ2�������ʾ�������мǹ�(default = 1).
% ���:
% pos - Nx2 ����ÿһ�а����߶Ȳ��������������(x,y) 
% scale - Nx3 ����ÿһ�а����߶Ȳ���������ĳ߶���Ϣ(��һ���ǳ߶Ȳ������������ڵ��飬
%   �ڶ����������ڵĲ�, �������ǳ߶Ȳ����������sigma).
% orient - Nx1 ������ÿ��Ԫ������������������䷶Χ�� [-pi,pi)֮��.
% desc - Nx128 ����ÿһ�а������������������.
% �ο�����:
% [1] David G. Lowe, "Distinctive Image Features from Sacle-Invariant Keypoints",
%     accepted for publicatoin in the International Journal of Computer
%     Vision, 2004.
% [2] David G. Lowe, "Object Recognition from Local Scale-Invariant Features",
%     Proc. of the International Conference on Computer Vision, Corfu,
%     September 1999.
%
% Xiaochuan ZHAO;zhaoxch@bit.edu.cn


% �趨��������Ĭ��ֵ
if ~exist('octaves')
   octaves = 4;
end
if ~exist('intervals')
   intervals = 2;
end
if ~exist('object_mask')
   object_mask = ones(size(im));
end
if size(object_mask) ~= size(im)
   object_mask = ones(size(im));
end
if ~exist('contrast_threshold')
   contrast_threshold = 0.02;
end
if ~exist('curvature_threshold')
   curvature_threshold = 10.0;
end
if ~exist('interactive')
   interactive = 1;
end


% ��������Ҷ�ͼ������ػҶ�ֵ�Ƿ��ѹ�һ����[0,1]
if( (min(im(:)) < 0) | (max(im(:)) > 1) )
   fprintf( 2, 'Warning: image not normalized to [0,1].\n' );
end


% ������ͼ�񾭹���˹ƽ����������˫���Բ�ֵ��������һ��.
if interactive >= 1
   fprintf( 2, 'Doubling image size for first octave...\n' );
end
tic;
antialias_sigma = 0.5;
if antialias_sigma == 0
   signal = im;
else
   g = gaussian_filter( antialias_sigma );
   if exist('corrsep') == 3
	   signal = corrsep( g, g, im );
   else
      signal = conv2( g, g, im, 'same' );
   end
end
signal = im;
[X Y] = meshgrid( 1:0.5:size(signal,2), 1:0.5:size(signal,1) );
signal = interp2( signal, X, Y, '*linear' );   
subsample = [0.5]; %  �������ʣ�


%��һ�������ɸ�˹�Ͳ�ָ�˹(DOG)�������������������������ݷֱ�洢����Ϊgauss_pyr{orient,interval}
% ��DOG_pyr{orient,interval}��Ԫ�������С���˹����������s+3�㣬��ָ�˹����������s+2�㡣
if interactive >= 1
   fprintf( 2, 'Prebluring image...\n' );
end
preblur_sigma = sqrt(sqrt(2)^2 - (2*antialias_sigma)^2);
if preblur_sigma == 0
   gauss_pyr{1,1} = signal;
else
   g = gaussian_filter( preblur_sigma );
   if exist('corrsep') == 3
      gauss_pyr{1,1} = corrsep( g, g, signal );
   else
      gauss_pyr{1,1} = conv2( g, g, signal, 'same' );
   end
end
clear signal
pre_time = toc;
if interactive >= 1
   fprintf( 2, 'Preprocessing time %.2f seconds.\n', pre_time );
end


% ��һ���һ���sigma
initial_sigma = sqrt( (2*antialias_sigma)^2 + preblur_sigma^2 );


% ��¼ÿһ���ÿһ���߶ȵ�sigma
absolute_sigma = zeros(octaves,intervals+3);
absolute_sigma(1,1) = initial_sigma * subsample(1);


% ��¼�������������˲����ĳߴ�ͱ�׼��
filter_size = zeros(octaves,intervals+3);
filter_sigma = zeros(octaves,intervals+3);


% ���ɸ�˹�Ͳ�ָ�˹������
if interactive >= 1
   fprintf( 2, 'Expanding the Gaussian and DOG pyramids...\n' );
end
tic;
for octave = 1:octaves
   if interactive >= 1
      fprintf( 2, '\tProcessing octave %d: image size %d x %d subsample %.1f\n', octave, size(gauss_pyr{octave,1},2), size(gauss_pyr{octave,1},1), subsample(octave) );
      fprintf( 2, '\t\tInterval 1 sigma %f\n', absolute_sigma(octave,1) );
   end   
   sigma = initial_sigma;
   g = gaussian_filter( sigma );
   filter_size( octave, 1 ) = length(g);
   filter_sigma( octave, 1 ) = sigma;
   DOG_pyr{octave} = zeros(size(gauss_pyr{octave,1},1),size(gauss_pyr{octave,1},2),intervals+2);
   for interval = 2:(intervals+3)
      

      % ����������һ�㼸�β����������ı�׼��
      % ���У�sigma_i+1 = k*sigma.
      %  sigma_i+1^2 = sigma_f,i^2 + sigma_i^2
      %  (k*sigma_i)^2 = sigma_f,i^2 + sigma_i^2
      % ���:
      %      sigma_f,i = sqrt(k^2 - 1)sigma_i
      %  ������չ���飨span the octave����k = 2^(1/intervals)
      % ����
      %  sigma_f,i = sqrt(2^(2/intervals) - 1)sigma_i
      
      sigma_f = sqrt(2^(2/intervals) - 1)*sigma;
      g = gaussian_filter( sigma_f );
      sigma = (2^(1/intervals))*sigma;
      

      % ��¼sigma��ֵ
      absolute_sigma(octave,interval) = sigma * subsample(octave);
      

      % ��¼�˲����ĳߴ�ͱ�׼��
      filter_size(octave,interval) = length(g);
      filter_sigma(octave,interval) = sigma;
      
      if exist('corrsep') == 3
         gauss_pyr{octave,interval} = corrsep( g, g, gauss_pyr{octave,interval-1} );
      else
         gauss_pyr{octave,interval} = conv2( g, g, gauss_pyr{octave,interval-1}, 'same' );
      end      
      DOG_pyr{octave}(:,:,interval-1) = gauss_pyr{octave,interval} - gauss_pyr{octave,interval-1};
      
      if interactive >= 1
         fprintf( 2, '\t\tInterval %d sigma %f\n', interval, absolute_sigma(octave,interval) );
      end              
   end      
   if octave < octaves
   
      sz = size(gauss_pyr{octave,intervals+1});
      [X Y] = meshgrid( 1:2:sz(2), 1:2:sz(1) );
      gauss_pyr{octave+1,1} = interp2(gauss_pyr{octave,intervals+1},X,Y,'*nearest'); 
      absolute_sigma(octave+1,1) = absolute_sigma(octave,intervals+1);
      subsample = [subsample subsample(end)*2];
   end      
end
pyr_time = toc;
if interactive >= 1
   fprintf( 2, 'Pryamid processing time %.2f seconds.\n', pyr_time );
end


% �ڽ���ģʽ����ʾ��˹������
if interactive >= 2
   sz = zeros(1,2);
   sz(2) = (intervals+3)*size(gauss_pyr{1,1},2);
   for octave = 1:octaves
      sz(1) = sz(1) + size(gauss_pyr{octave,1},1);
   end
   pic = zeros(sz);
   y = 1;
   for octave = 1:octaves
      x = 1;
      sz = size(gauss_pyr{octave,1});
      for interval = 1:(intervals + 3)
			pic(y:(y+sz(1)-1),x:(x+sz(2)-1)) = gauss_pyr{octave,interval};		         
         x = x + sz(2);
      end
      y = y + sz(1);
   end
   fig = figure;
   clf;
   imshow(pic);
   resizeImageFig( fig, size(pic), 0.25 );
   fprintf( 2, 'The gaussian pyramid (0.25 scale).\nPress any key to continue.\n' );
   pause;
   close(fig)
end


% �ڽ���ģʽ����ʾ��ָ�˹������
if interactive >= 2
   sz = zeros(1,2);
   sz(2) = (intervals+2)*size(DOG_pyr{1}(:,:,1),2);
   for octave = 1:octaves
      sz(1) = sz(1) + size(DOG_pyr{octave}(:,:,1),1);
   end
   pic = zeros(sz);
   y = 1;
   for octave = 1:octaves
      x = 1;
      sz = size(DOG_pyr{octave}(:,:,1));
      for interval = 1:(intervals + 2)
			pic(y:(y+sz(1)-1),x:(x+sz(2)-1)) = DOG_pyr{octave}(:,:,interval);		         
         x = x + sz(2);
      end
      y = y + sz(1);
   end
   fig = figure;
   clf;
   imagesc(pic);
   resizeImageFig( fig, size(pic), 0.25 );
   fprintf( 2, 'The DOG pyramid (0.25 scale).\nPress any key to continue.\n' );
   pause;
   close(fig)
end


% ��һ���ǲ��Ҳ�ָ�˹�������еľֲ���ֵ����ͨ�����ʺ��նȽ��м���
curvature_threshold = ((curvature_threshold + 1)^2)/curvature_threshold;

 
% ����΢�ֺ�
xx = [ 1 -2  1 ];
yy = xx';
xy = [ 1 0 -1; 0 0 0; -1 0 1 ]/4;


raw_keypoints = [];
contrast_keypoints = [];
curve_keypoints = [];


% �ڸ�˹�������в��Ҿֲ���ֵ
if interactive >= 1
   fprintf( 2, 'Locating keypoints...\n' );
end
tic;
loc = cell(size(DOG_pyr)); 
for octave = 1:octaves
   if interactive >= 1
      fprintf( 2, '\tProcessing octave %d\n', octave );
   end
   for interval = 2:(intervals+1)
      keypoint_count = 0;
      contrast_mask = abs(DOG_pyr{octave}(:,:,interval)) >= contrast_threshold;
      loc{octave,interval} = zeros(size(DOG_pyr{octave}(:,:,interval)));
      if exist('corrsep') == 3
         edge = 1;
      else         
         edge = ceil(filter_size(octave,interval)/2);
      end      
      for y=(1+edge):(size(DOG_pyr{octave}(:,:,interval),1)-edge)         
         for x=(1+edge):(size(DOG_pyr{octave}(:,:,interval),2)-edge)
            
            if object_mask(round(y*subsample(octave)),round(x*subsample(octave))) == 1 
               
               
               if( (interactive >= 2) | (contrast_mask(y,x) == 1) ) 
                  
                  
                  % ͨ���ռ�˳߶ȼ�����ֵ����Сֵ
                  tmp = DOG_pyr{octave}((y-1):(y+1),(x-1):(x+1),(interval-1):(interval+1));  
                  pt_val = tmp(2,2,2);
                  if( (pt_val == min(tmp(:))) | (pt_val == max(tmp(:))) )

                     % �洢�ԻҶȴ��ڶԱȶ���ֵ�ĵ������
                     raw_keypoints = [raw_keypoints; x*subsample(octave) y*subsample(octave)];
                     
                     if abs(DOG_pyr{octave}(y,x,interval)) >= contrast_threshold

                        contrast_keypoints = [contrast_keypoints; raw_keypoints(end,:)];
                        

                        % ����ֲ���ֵ��Hessian����
                        Dxx = sum(DOG_pyr{octave}(y,x-1:x+1,interval) .* xx);
                        Dyy = sum(DOG_pyr{octave}(y-1:y+1,x,interval) .* yy);
                        Dxy = sum(sum(DOG_pyr{octave}(y-1:y+1,x-1:x+1,interval) .* xy));
                        

                        % ����Hessian�����ֱ��������ʽ.
                        Tr_H = Dxx + Dyy;
                        Det_H = Dxx*Dyy - Dxy^2;
                        

                        % ����������.
                        curvature_ratio = (Tr_H^2)/Det_H;
                        
                        if ((Det_H >= 0) & (curvature_ratio < curvature_threshold))

                           % �洢������С����ֵ�ĵļ�ֵ������꣨�Ǳ�Ե�㣩
                           curve_keypoints = [curve_keypoints; raw_keypoints(end,:)];
                           
                           % ���õ��λ�õ�������Ϊ1��������������.
                           loc{octave,interval}(y,x) = 1;
                           keypoint_count = keypoint_count + 1;
                        end
                     end                  
                  end
               end               
            end
         end         
      end
      if interactive >= 1
         fprintf( 2, '\t\t%d keypoints found on interval %d\n', keypoint_count, interval );
      end
   end
end
keypoint_time = toc;
if interactive >= 1
   fprintf( 2, 'Keypoint location time %.2f seconds.\n', keypoint_time );
end   


% �ڽ���ģʽ����ʾ��������Ľ��.
if interactive >= 2
   fig = figure;
   clf;
   imshow(im);
   hold on;
   plot(raw_keypoints(:,1),raw_keypoints(:,2),'y+');
   resizeImageFig( fig, size(im), 2 );
   fprintf( 2, 'DOG extrema (2x scale).\nPress any key to continue.\n' );
   pause;
   close(fig);
   fig = figure;
   clf;
   imshow(im);
   hold on;
   plot(contrast_keypoints(:,1),contrast_keypoints(:,2),'y+');
   resizeImageFig( fig, size(im), 2 );
   fprintf( 2, 'Keypoints after removing low contrast extrema (2x scale).\nPress any key to continue.\n' );
   pause;
   close(fig);
   fig = figure;
   clf;
   imshow(im);
   hold on;
   plot(curve_keypoints(:,1),curve_keypoints(:,2),'y+');
   resizeImageFig( fig, size(im), 2 );
   fprintf( 2, 'Keypoints after removing edge points using principal curvature filtering (2x scale).\nPress any key to continue.\n' );
   pause;
   close(fig);  
end
clear raw_keypoints contrast_keypoints curve_keypoints


% ��һ���Ǽ����������������.  
% ���������һ�������ڼ������ݶ�ֱ��ͼ
g = gaussian_filter( 1.5 * absolute_sigma(1,intervals+3) / subsample(1) );
zero_pad = ceil( length(g) / 2 );


% �����˹������ͼ����ݶȷ���ͷ�ֵ
if interactive >= 1
   fprintf( 2, 'Computing gradient magnitude and orientation...\n' );
end
tic;
mag_thresh = zeros(size(gauss_pyr));
mag_pyr = cell(size(gauss_pyr));
grad_pyr = cell(size(gauss_pyr));
for octave = 1:octaves
   for interval = 2:(intervals+1)      
      
      % ����x,y�Ĳ��
      diff_x = 0.5*(gauss_pyr{octave,interval}(2:(end-1),3:(end))-gauss_pyr{octave,interval}(2:(end-1),1:(end-2)));
      diff_y = 0.5*(gauss_pyr{octave,interval}(3:(end),2:(end-1))-gauss_pyr{octave,interval}(1:(end-2),2:(end-1)));
      
      
      % �����ݶȷ�ֵ
      mag = zeros(size(gauss_pyr{octave,interval}));      
      mag(2:(end-1),2:(end-1)) = sqrt( diff_x .^ 2 + diff_y .^ 2 );
      
      
      % �洢��˹�������ݶȷ�ֵ
      mag_pyr{octave,interval} = zeros(size(mag)+2*zero_pad);
      mag_pyr{octave,interval}((zero_pad+1):(end-zero_pad),(zero_pad+1):(end-zero_pad)) = mag;      
      
      
      % �����ݶ�������
      grad = zeros(size(gauss_pyr{octave,interval}));
      grad(2:(end-1),2:(end-1)) = atan2( diff_y, diff_x );
      grad(find(grad == pi)) = -pi;
      
      
      % �洢��˹�������ݶ�������
      grad_pyr{octave,interval} = zeros(size(grad)+2*zero_pad);
      grad_pyr{octave,interval}((zero_pad+1):(end-zero_pad),(zero_pad+1):(end-zero_pad)) = grad;
   end
end
clear mag grad
grad_time = toc;
if interactive >= 1
   fprintf( 2, 'Gradient calculation time %.2f seconds.\n', grad_time );
end


% ��һ����ȷ���������������
% ������ͨ��Ѱ��ÿ���ؼ�������������ݶ�ֱ��ͼ�ķ�ֵ��ע��ÿ���ؼ��������������в�ֹһ����


% ���Ҷ�ֱ��ͼ��Ϊ36�ȷ֣�ÿ��10��һ��
num_bins = 36;
hist_step = 2*pi/num_bins;
hist_orient = [-pi:hist_step:(pi-hist_step)];


% ��ʼ���ؼ����λ�á�����ͳ߶���Ϣ
pos = [];
orient = [];
scale = [];


% ���ؼ���ȷ��������
if interactive >= 1
   fprintf( 2, 'Assigining keypoint orientations...\n' );
end
tic;
for octave = 1:octaves
   if interactive >= 1
      fprintf( 2, '\tProcessing octave %d\n', octave );
   end
   for interval = 2:(intervals + 1)
      if interactive >= 1
         fprintf( 2, '\t\tProcessing interval %d ', interval );
      end            
      keypoint_count = 0;
      

      % �����˹��Ȩ��ģ
      g = gaussian_filter( 1.5 * absolute_sigma(octave,interval)/subsample(octave) );
      hf_sz = floor(length(g)/2);
      g = g'*g;      
      

      loc_pad = zeros(size(loc{octave,interval})+2*zero_pad);
      loc_pad((zero_pad+1):(end-zero_pad),(zero_pad+1):(end-zero_pad)) = loc{octave,interval};
      

      [iy ix]=find(loc_pad==1);
      for k = 1:length(iy)

         x = ix(k);
         y = iy(k);
         wght = g.*mag_pyr{octave,interval}((y-hf_sz):(y+hf_sz),(x-hf_sz):(x+hf_sz));
         grad_window = grad_pyr{octave,interval}((y-hf_sz):(y+hf_sz),(x-hf_sz):(x+hf_sz));
         orient_hist=zeros(length(hist_orient),1);
         for bin=1:length(hist_orient)
            
            diff = mod( grad_window - hist_orient(bin) + pi, 2*pi ) - pi;
            
            
            orient_hist(bin)=orient_hist(bin)+sum(sum(wght.*max(1 - abs(diff)/hist_step,0)));

         end
         

         % ���÷Ǽ������Ʒ�����������ֱ��ͼ�ķ�ֵ
         peaks = orient_hist;        
         rot_right = [ peaks(end); peaks(1:end-1) ];
         rot_left = [ peaks(2:end); peaks(1) ];         
         peaks( find(peaks < rot_right) ) = 0;
         peaks( find(peaks < rot_left) ) = 0;
         

         % ��ȡ����ֵ��ֵ��������λ�� 
         [max_peak_val ipeak] = max(peaks);
         

         % �����ڵ�������ֵ80% ��ֱ��ͼ��Ҳȷ��Ϊ�������������
         peak_val = max_peak_val;
         while( peak_val > 0.8*max_peak_val )
	
            % ��߷�ֵ�����������ֵͨ�������߲�ֵ��ȷ�õ�
            A = [];
            b = [];
            for j = -1:1
               A = [A; (hist_orient(ipeak)+hist_step*j).^2 (hist_orient(ipeak)+hist_step*j) 1];
	            bin = mod( ipeak + j + num_bins - 1, num_bins ) + 1;
               b = [b; orient_hist(bin)];
            end
            c = pinv(A)*b;
            max_orient = -c(2)/(2*c(1));
            while( max_orient < -pi )
               max_orient = max_orient + 2*pi;
            end
            while( max_orient >= pi )
               max_orient = max_orient - 2*pi;
            end            
            

            % �洢�ؼ����λ�á�������ͳ߶���Ϣ
            pos = [pos; [(x-zero_pad) (y-zero_pad)]*subsample(octave) ];
            orient = [orient; max_orient];
            scale = [scale; octave interval absolute_sigma(octave,interval)];
            keypoint_count = keypoint_count + 1;
            

            peaks(ipeak) = 0;
            [peak_val ipeak] = max(peaks);
         end         
      end
      if interactive >= 1
         fprintf( 2, '(%d keypoints)\n', keypoint_count );
      end            
   end
end
clear loc loc_pad 
orient_time = toc;
if interactive >= 1
   fprintf( 2, 'Orientation assignment time %.2f seconds.\n', orient_time );
end


% �ڽ���ģʽ����ʾ�ؼ���ĳ߶Ⱥ���������Ϣ
if interactive >= 2
   fig = figure;
   clf;
   imshow(im);
   hold on;
   display_keypoints( pos, scale(:,3), orient, 'y' );
   resizeImageFig( fig, size(im), 2 );
   fprintf( 2, 'Final keypoints with scale and orientation (2x scale).\nPress any key to continue.\n' );
   pause;
   close(fig);
end


% SIFT �㷨�����һ����������������


orient_bin_spacing = pi/4;
orient_angles = [-pi:orient_bin_spacing:(pi-orient_bin_spacing)];


grid_spacing = 4;
[x_coords y_coords] = meshgrid( [-6:grid_spacing:6] );
feat_grid = [x_coords(:) y_coords(:)]';
[x_coords y_coords] = meshgrid( [-(2*grid_spacing-0.5):(2*grid_spacing-0.5)] );
feat_samples = [x_coords(:) y_coords(:)]';
feat_window = 2*grid_spacing;


desc = [];


if interactive >= 1
   fprintf( 2, 'Computing keypoint feature descriptors for %d keypoints', size(pos,1) );
end
for k = 1:size(pos,1)
   x = pos(k,1)/subsample(scale(k,1));
   y = pos(k,2)/subsample(scale(k,1));   
   

   % ����������תΪ�ؼ���ķ�����ȷ����ת������
   M = [cos(orient(k)) -sin(orient(k)); sin(orient(k)) cos(orient(k))];
   feat_rot_grid = M*feat_grid + repmat([x; y],1,size(feat_grid,2));
   feat_rot_samples = M*feat_samples + repmat([x; y],1,size(feat_samples,2));
   

   % ��ʼ����������.
   feat_desc = zeros(1,128);
   

   for s = 1:size(feat_rot_samples,2)
      x_sample = feat_rot_samples(1,s);
      y_sample = feat_rot_samples(2,s);
      

      % �ڲ���λ�ý����ݶȲ�ֵ
      [X Y] = meshgrid( (x_sample-1):(x_sample+1), (y_sample-1):(y_sample+1) );
      G = interp2( gauss_pyr{scale(k,1),scale(k,2)}, X, Y, '*linear' );
      G(find(isnan(G))) = 0;
      diff_x = 0.5*(G(2,3) - G(2,1));
      diff_y = 0.5*(G(3,2) - G(1,2));
      mag_sample = sqrt( diff_x^2 + diff_y^2 );
      grad_sample = atan2( diff_y, diff_x );
      if grad_sample == pi
         grad_sample = -pi;
      end      
      

      % ����x��y�����ϵ�Ȩ��
      x_wght = max(1 - (abs(feat_rot_grid(1,:) - x_sample)/grid_spacing), 0);
      y_wght = max(1 - (abs(feat_rot_grid(2,:) - y_sample)/grid_spacing), 0); 
      pos_wght = reshape(repmat(x_wght.*y_wght,8,1),1,128);
      

      diff = mod( grad_sample - orient(k) - orient_angles + pi, 2*pi ) - pi;
      orient_wght = max(1 - abs(diff)/orient_bin_spacing,0);
      orient_wght = repmat(orient_wght,1,16);         
      

      % �����˹Ȩ��
      g = exp(-((x_sample-x)^2+(y_sample-y)^2)/(2*feat_window^2))/(2*pi*feat_window^2);
      

      feat_desc = feat_desc + pos_wght.*orient_wght*g*mag_sample;
   end
   

   % �����������ĳ��ȹ�һ��������Խ�һ��ȥ�����ձ仯��Ӱ��.
   feat_desc = feat_desc / norm(feat_desc);
   

   feat_desc( find(feat_desc > 0.2) ) = 0.2;
   feat_desc = feat_desc / norm(feat_desc);
   

   % �洢��������.
   desc = [desc; feat_desc];
   if (interactive >= 1) & (mod(k,25) == 0)
      fprintf( 2, '.' );
   end
end
desc_time = toc;


% ��������ƫ��
sample_offset = -(subsample - 1);
for k = 1:size(pos,1)
   pos(k,:) = pos(k,:) + sample_offset(scale(k,1));
end


if size(pos,1) > 0
	scale = scale(:,3);
end
   

% �ڽ���ģʽ����ʾ���й��̺�ʱ.
if interactive >= 1
   fprintf( 2, '\nDescriptor processing time %.2f seconds.\n', desc_time );
   fprintf( 2, 'Processing time summary:\n' );
   fprintf( 2, '\tPreprocessing:\t%.2f s\n', pre_time );
   fprintf( 2, '\tPyramid:\t%.2f s\n', pyr_time );
   fprintf( 2, '\tKeypoints:\t%.2f s\n', keypoint_time );
   fprintf( 2, '\tGradient:\t%.2f s\n', grad_time );
   fprintf( 2, '\tOrientation:\t%.2f s\n', orient_time );
   fprintf( 2, '\tDescriptor:\t%.2f s\n', desc_time );
   fprintf( 2, 'Total processing time %.2f seconds.\n', pre_time + pyr_time + keypoint_time + grad_time + orient_time + desc_time );
end
