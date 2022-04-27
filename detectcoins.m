function [howmuch, coinareas] = detectcoins2(coinfilename,threshold,radius1,radius2)
imbg = imread('background.jpeg');
imbg = rgb2gray(imbg);
imcoin = imread(coinfilename);
imcoins1 = rgb2gray(imcoin);
imdiff = abs(imcoins1 - imbg);
imdiffb = imdiff > threshold;

imclean1=imerode(imdiffb,strel('disk',radius1,0));
imclean=imdilate(imclean1,strel('disk',radius1,0));

imnoholes = imclose(imclean,strel('disk',radius2,0));

figure(8)
subplot(1,3,1);
imshow(imbg)
subplot(1,3,2);
imshow(imcoins1)
subplot(1,3,3);
imshow(~imnoholes);
title 'Detected Coins'; % show detected coins

[imcc, n] = bwlabel(imnoholes);
coinareas=zeros(n,1); % allocate array for areas

for i=1:n % repeat for each coin
coinareas(i)=sum(imcc(:) == i ); % area of ith coin
end

howmuch=0; % monetary value of coins
coinareas=zeros(n,1); % allocate array for areas
firstupperbound = 2100; % approx # of pixels in your smallest coin
secondupperbound = 3000; % approx # of pixels in 2nd smallest coin
thirdupperbound = 4000; % approx # of pixels in largest coin
for i=1:n % repeat for each coin
coinareas(i)=sum( imcc(:) == i ); % area of ith coin
if coinareas(i) < firstupperbound howmuch = howmuch + 10; % its a dime
elseif (coinareas(i) >= firstupperbound) & (coinareas(i) < secondupperbound)
howmuch = howmuch + 5; % its a nickel
elseif coinareas(i) >= secondupperbound howmuch = howmuch + 25; % its a quarter
end
end
