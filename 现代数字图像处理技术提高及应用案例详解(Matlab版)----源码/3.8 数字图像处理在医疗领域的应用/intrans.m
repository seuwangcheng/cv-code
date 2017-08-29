function g = intrans(f, varargin)
%   功能：灰度级转换
%   输入：f-待转换的图像
%   输出：g-转换后的图像
%   说明：g= intrans(f, 'neg')计算输入图像的负图像
%         g= intrans(f, 'log',C,CLASS)计算C*log(1 + f)
%         g= intrans(f, 'gamma', GAM)计算输入图像的gamma变换
%         g= intrans(f, 'stretch', M, E)计算1./(1 + (M./(F +eps)).^E)

% 图像类型转换
if strcmp(class(f), 'double') & max(f(:)) > 1 & ...
      ~strcmp(varargin{1}, 'log')
   f = mat2gray(f);
else    f = im2double(f);
end
 
method = varargin{1};
 
% 执行指定的灰度对比增强运算    
switch method
case 'neg' 
   g = imcomplement(f); 
 
case 'log'
   if length(varargin) == 1  
      c = 1;
   elseif length(varargin) == 2  
      c = varargin{2}; 
   elseif length(varargin) == 3 
      c = varargin{2}; 
      classin = varargin{3};
   else 
      error('Incorrect number of inputs for the log option.')
   end
   g = c*(log(1 + double(f)));
 
case 'gamma'
   if length(varargin) < 2
      error('Not enough inputs for the gamma option.')
   end
   gam = varargin{2}; 
   g = imadjust(f, [ ], [ ], gam);
   
case 'stretch'
   if length(varargin) == 1
      % 采用默认值
      m = mean2(f);  
      E = 4.0;           
   elseif length(varargin) == 3
      m = varargin{2};  
      E = varargin{3};
   else error('Incorrect number of inputs for the stretch option.')
   end
   g = 1./(1 + (m./(f + eps)).^E);
otherwise
   error('Unknown enhancement method.')
end
