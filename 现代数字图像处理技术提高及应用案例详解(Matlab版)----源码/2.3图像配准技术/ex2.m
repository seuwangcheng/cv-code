img=imread('hall1.jpg');
img=rgb2gray(img);
img=double(img);
mask=imread('mask.jpg');
mask=rgb2gray(mask);
mask=double(mask);
[maskH, maskW] = size(mask);
[imgH, imgW] = size(img);
energyMask = 0;
for n=1:maskH
    for m=1:maskW
        energyMask = energyMask + mask(n,m)*mask(n,m);
    end
end
if(energyMask == 0)
    energyMask = 1;
end
energyMask= sqrt(energyMask);
R = zeros(imgH, imgW);
for y=1:(imgH-maskH)
    for x = 1:(imgW-maskW)
        relateVal = 0;
        energySubImage = 0;
        for n=1:maskH
            for m=1:maskW
                relateVal = relateVal+ img(y+n-1,x+m-1)*mask(n,m);
    energySubImage = energySubImage + img(y+n-1,x+m-1)*img(y+n-1,x+m-1);
            end
        end
        energySubImage= sqrt(energySubImage);
        if(energySubImage == 0)
            energySubImage = 1;
        end
        R(y,x) = relateVal/(energySubImage*energyMask);
        aaa = R(y,x);
        if(R(y,x)>=0.97)
            y
            x
        end
    end
end
