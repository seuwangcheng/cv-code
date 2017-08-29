% ��ȡ�������ͼ�񣬽���ת��Ϊ�Ҷ�ͼ
I = imread('ranseti.bmp');
figure,imshow(I);
I2 = rgb2gray(I);
s = size(I2);
I4 = 255*ones(s(1), s(2), 'uint8');
I5 = imsubtract(I4,I2);
%��ͼ�������ֵ�˲�ȥ������
I3 = medfilt2(I5,[5 5]);
%��ͼ��ת��Ϊ��ֵͼ��
I3 = imadjust(I3);
bw = im2bw(I3, 0.3);
%ȥ��ͼ���������С�ģ����Կ϶�����Ⱦɫ����ӵ�
bw = bwareaopen(bw, 10);
figure,imshow(bw);
%�����ͨ�������Ա�ͳ��Ⱦɫ�����������
[labeled,numObjects] = bwlabel(bw,4);
%����ɫ���ÿһ��Ⱦɫ�壬�Ա�ֱ����ʾ
RGB_label=label2rgb(labeled,@spring,'c','shuffle');
figure,imshow(RGB_label);
%ͳ�Ʊ���ǵ�Ⱦɫ�����������ֲ�����ʾȾɫ������
chrdata = regionprops(labeled,'basic')
allchrs = [chrdata.Area];
num = size(allchrs)
nbins = 20;
figure,hist(allchrs,nbins);
title(num(2))
