function [howmuch, coinareas] = detectcoins(coinfilename,threshold,radius1,radius2)

%% Problem 3: Machine Vision & Image Processing via MATLAB (34 points)
%% 1.1 Processing Images with MATLAB
%% 1.1.1 Starting up MATLAB and downloading the images
%% 1.1.2 Forming the Binary Image
A = imread('background.jpeg');
imbg = rgb2gray(A);

imcoin = imread(coinfilename);
imcoins1 = rgb2gray(imcoin);

figure(1)
subplot(1,2,1);
imshow(imbg)
subplot(1,2,2);
imshow(imcoins1)
hold off
%% 1.1.3 Background Subtraction
imdiff = abs(imcoins1 - imbg);
%% 1.1.4 Thresholding
imdiffb = imdiff > threshold;
figure(2)
imshow(imdiffb)
hold off
%% 1.1.5 Eliminating Noise
figure(3)
subplot(1,2,1);
se3 = strel('disk',3,0);
imshow(se3.Neighborhood)
subplot(1,2,2);
se4 = strel('disk',4,0);
imshow(se4.Neighborhood)
%% 1.1.6 Eliminating Noise
seo=strel('disk',3,0);
imer=imerode(imdiffb,seo);
imdi=imdilate(imdiffb,seo);
figure(4)
subplot(1,2,1);
imshow(imer)
subplot(1,2,2);
imshow(imdi)
% a
seo=strel('disk',radius1,0);
imclean1=imerode(imdiffb,seo);
imclean=imdilate(imclean1,seo);
figure(5)
subplot(1,2,1);
imshow(imclean1)
subplot(1,2,2);
imshow(imclean)
% b
imclean2 = imclose(imclean,strel('disk',radius2,0));
figure(6)
imshow(imclean2)
% c
imnoholes = imclose(imclean,strel('disk',radius2,0));
figure(7)
imshow(imnoholes)
%% 1.1.7 Displaying Your Results
% commands pasted from above, to allow script from earlier questions to
% remain
figure(8)
subplot(1,3,1);
imshow(imbg)
subplot(1,3,2);
imshow(imcoins1)
subplot(1,3,3);
imshow(~imnoholes);
title 'Detected Coins';
[imcc, n] = bwlabel(imnoholes);
coinareas=zeros(n,1); % allocate array for areas
for i=1:n % repeat for each coin2
coinareas(i)=sum(imcc(:) == i ); % area of ith coin
end

howmuch=0; % monetary value of coins
coinareas=zeros(n,1); % allocate array for areas
firstupperbound = 2100; % approx # of pixels in your smallest coin
secondupperbound = 3000; % approx # of pixels in 2nd smallest coin
thirdupperbound = 4000;
for i=1:n % repeat for each coin
coinareas(i)=sum( imcc(:) == i ); % area of ith coin
if coinareas(i) < firstupperbound howmuch = howmuch + 10; % its a dime
elseif (coinareas(i) >= firstupperbound) & (coinareas(i) < secondupperbound)
howmuch = howmuch + 5; % its a nickel
elseif coinareas(i) >= secondupperbound howmuch = howmuch + 25; % its a quarter
end
end
