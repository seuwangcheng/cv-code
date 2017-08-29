% ��ȡ�������ͼ�񣬽���ת��Ϊ��ֵͼ��
I = imread('car.jpg'); 
I2 = rgb2gray(I);
I4 = im2bw(I2, 0.2);
% ȥ��ͼ���������С�ġ����Կ϶����ǳ��Ƶ�����
bw = bwareaopen(I4, 500);
% Ϊ��λ���ƣ�����ɫ�������ͣ���ʴȥ�޹ص�С���
se = strel('disk',15);
bw = imclose(bw,se);
bw = imfill(bw,[1 1]);
% ������ͨ��߽�
[B,L] = bwboundaries(bw,4);
imshow(label2rgb(L, @jet, [.5 .5 .5]))
hold on
% �ҳ�������ͨ����������ǳ��Ƶ���һ��
for k = 1:length(B)
 boundary = B{k};
 plot(boundary(:,2),boundary(:,1),'w','LineWidth',2)
end
% �ҵ�ÿ����ͨ�������
stats = regionprops(L,'Area','Centroid');
% ѭ������ÿ����ͨ��ı߽�
for k = 1:length(B)
  % ��ȡһ���߽��ϵ����е�
  boundary = B{k};
  % ����߽��ܳ�
  delta_sq = diff(boundary).^2;    
  perimeter = sum(sqrt(sum(delta_sq,2)));
  % ��ȡ�߽���Χ���
  area = stats(k).Area;
  % ����ƥ���
  metric = 27*area/perimeter^2;
  % Ҫ��ʾ��ƥ����ִ�
  metric_string = sprintf('%2.2f',metric);
  % ��ǳ�ƥ��Ƚӽ�1����ͨ��
  if metric >= 0.9 && metric <= 1.1
    centroid = stats(k).Centroid;
    plot(centroid(1),centroid(2),'ko');
    % ��ȡ����ͨ������Ӧ�ڶ�ֵͼ���еľ�������
    goalboundary = boundary; 
    s = min(goalboundary, [], 1);
    e = max(goalboundary, [], 1);
  goal = imcrop(I4,[s(2) s(1) e(2)-s(2) e(1)-s(1)]); 
  end
  % ��ʾƥ����ִ�
  text(boundary(1,2)-35,boundary(1,1)+13,...
    metric_string,'Color','g',...
'FontSize',14,'FontWeight','bold');
end
goal = ~goal;
goal(256,256) = 0;
figure;
imshow(goal);
w = imread('P.bmp');
w = ~w;
C=real(ifft2(fft2(goal).*fft2(rot90(w,2),256,256)));
thresh = 240;
figure;
imshow(C > thresh);
