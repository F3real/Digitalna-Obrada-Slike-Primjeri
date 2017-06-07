
%% task 1 2 3 4 5 6
a = imread('lena.jpg');

% to open help for imread type
% help imread
% in command window

% a(:) is column representation of matrix, basically creates one colum from
% all columns in matrix

max_a = max(a(:));
min_a = min(a(:));

figure, imshow(a), title('Lena imshow');

%show intensity scale on image
figure, imshow(a), title('Lena colorbar'), colorbar;

% imtool shows cordinates of selected pixels and their value
imtool(a);

%% task 7
a = imread('lena.jpg');
% shows cordinates of selected pixels and their value
figure, imshow(a), title('Lena imshow pixel info'), impixelinfo;

%% task 8
a = imread('lena.jpg');
b = im2double(a);
figure, imshow(b), title('Lena double');

%% task 9

lena_info = imfinfo('lena.jpg');

%% task 10
a = imread('lena.jpg');
imwrite(a, 'lenaTIFF.tiff', 'tiff');
imwrite(a, 'lena0.jpg', 'jpg', 'Quality', 0);
imwrite(a, 'lena5.jpg', 'jpg', 'Quality',5);
imwrite(a, 'lena15.jpg', 'jpg', 'Quality',15);
imwrite(a, 'lena25.jpg', 'jpg', 'Quality',25);
imwrite(a, 'lena25.jpg', 'jpg', 'Quality',50);

%% task 11
blobs_info = imfinfo('blobs.png');

%% task 12 13

a = dicomread('CT_pluca.dcm');
ct_info = dicominfo('CT_pluca.dcm');
figure, imshow(a), title('CT pluca');

figure, imshow(a, []), title('CT pluca []');
figure, imshow(a, [864 1264]), title('CT pluca [864 1264]');
%% task 14

a = dicomread('CT_pluca.dcm');

b = double(a);
% converts the matrix A to the intensity image I. The returned matrix I 
%contains values in the range 0.0 (black) to 1.0 (full intensity or white)
b1 = mat2gray(b, [864 1264]);
figure, imshow(b1), title('CT pluca mat2gray');

% converts the intensity image I to double precision,
c = im2double(a);
figure, imshow(c), title('CT pluca im2double');

%% task 15
a = imread('lena.jpg');
% start:increment:end
a1 = a(:,end:-1:1);
figure, imshow(a), title('Lena org');
figure, imshow(a1), title('Lena rotate');

a(1:2:end,1:2:end) = 2;
figure, imshow(a), title('Lena %2');







