function test()
%读入第一幅图像并进行Harris角点检测;
    img11 = imread('scence1.jpg');
    img1 = rgb2gray(img11);
    img1 = double(img1(:,:));
    pt1 = kp_harris(img1);
%读入第二幅图像并进行Harris角点检测;
    img21 = imread('scence2.jpg');
    img2 = rgb2gray(img21);
    img2 = double(img2(:,:));
pt2 = kp_harris(img2);
% 进行匹配
    result = match(img1,pt1,img2,pt2);
    result(1,intersect(find(result(1,:) > 0),find(result(2,:) == 0))) = 0;
    while(length(find(result(1,:)>0)) > 3)     
        result
        draw2(img11,img21,pt1,pt2,result);
        pause;
        [index index] = max(result(2,:));
        result(1,index(1)) = 0;
        result(2,index(1)) = 0;
     end
    draw2(img11,img21,pt1,pt2,result);
end
