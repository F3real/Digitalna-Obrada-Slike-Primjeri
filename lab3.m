%% task 1

a = imread('lena.jpg');

f3 = fspecial('average', [3 3]);
f5 = fspecial('average', [5 5]);
f7 = fspecial('average', [7 7]);

a3 = imfilter(a, f3);
a5 = imfilter(a, f5);
a7 = imfilter(a, f7);

figure, imshow(a), title('Lena'), impixelinfo;
figure, imshow(a3), title('Lena 3x3'), impixelinfo;
figure, imshow(a5), title('Lena 5x5'), impixelinfo;
figure, imshow(a7), title('Lena 7x7'), impixelinfo;

%% task 2
a = imread('lena.jpg');

f7 = fspecial('average', [7 7]);
a7 = imfilter(a, f7, 'replicate');

figure, imshow(a), title('Lena'), impixelinfo;
figure, imshow(a7), title('Lena 7x7'), impixelinfo;

%% task 3
a = imread('lena.jpg');
a = im2double(a);

a1 = imnoise(a,'salt & pepper', 0.1);

f3 = fspecial('average', [3 3]);
au3 = imfilter(a1, f3);

w3 = wiener2(a1 ,[3 3]);
w3_n = wiener2(a1 ,[3 3], 0.1);
w5 = wiener2(a1 ,[5 5]);
w5_n = wiener2(a1 ,[5 5],0.1);

m3 = medfilt2(a, [3 3], 'symmetric');

%figure, imshow(a, []), title('Lena'), impixelinfo;
%figure, imshow(a1, []), title('Lena salt & pepper'), impixelinfo;
%figure, imshow(au3), title('Lena 3x3'), impixelinfo;

figure, imshow(w3), title('Lena w 3x3'), impixelinfo;
figure, imshow(w3_n), title('Lena w 3x3 n'), impixelinfo;
figure, imshow(w5), title('Lena w 5x5'), impixelinfo;
figure, imshow(w5_n), title('Lena w 5x5 n'), impixelinfo;

figure, imshow(m3), title('Lena m 3x3'), impixelinfo;

err_u = immse(a1,au3);
err_w3 = immse(a1,w3);
err_w3n = immse(a1,w3_n);
err_w5 = immse(a1,w5);
err_w5n = immse(a1,w5_n);
err_m3 = immse(a1,m3);
%% task 4
a = imread('lena.jpg');
a = im2double(a);

a1 = imnoise(a,'gaussian',0, 0.005);

f3 = fspecial('average', [3 3]);
au3 = imfilter(a1, f3);

w3 = wiener2(a1 ,[3 3]);
w3_n = wiener2(a1 ,[3 3], 0.005);
w5 = wiener2(a1 ,[5 5]);
w5_n = wiener2(a1 ,[5 5],0.005);

m3 = medfilt2(a, [3 3], 'symmetric');

figure, imshow(a, []), title('Lena'), impixelinfo;
figure, imshow(a1, []), title('Lena gaussian'), impixelinfo;
figure, imshow(au3), title('Lena 3x3'), impixelinfo;

figure, imshow(w3), title('Lena w 3x3'), impixelinfo;
figure, imshow(w3_n), title('Lena w 3x3 n'), impixelinfo;
figure, imshow(w5), title('Lena w 5x5'), impixelinfo;
figure, imshow(w5_n), title('Lena w 5x5 n'), impixelinfo;

figure, imshow(m3), title('Lena m 3x3'), impixelinfo;

err_u = immse(a1,au3);
err_w3 = immse(a1,w3);
err_w3n = immse(a1,w3_n);
err_w5 = immse(a1,w5);
err_w5n = immse(a1,w5_n);
err_m3 = immse(a1,m3);

%% task 5
a = imread('lena.jpg');
a = im2double(a);

f5 = fspecial('average', [5 5]);
a5 = imfilter(a, f5);

fl = fspecial('laplacian');
afl = imfilter(a, fl);

aflg = mat2gray(afl);

figure, imshow(afl, []), title('Lena laplacian'), impixelinfo;
figure, imshow(aflg, []), title('Lena m laplacian'), impixelinfo;

figure, imshow(a - aflg, []), title('Lena m laplacian'), impixelinfo;

%% task 6
a = imread('lena.jpg');
a = im2double(a);

a1 = imnoise(a,'gaussian',0, 0.005);

f5 = fspecial('average', [5 5]);
a5 = imfilter(a1, f5);

fl = fspecial('laplacian');
afl = imfilter(a5, fl);

res = a5 - afl;
figure, imshow(a5, []), title('Lena average'), impixelinfo;
figure, imshow(afl, []), title('Lena laplacian'), impixelinfo;
figure, imshow(res, []), title('Lena diff'), impixelinfo;

%% notes
% salt & pepper noise -> median filter
%
% wiener filter -> when noise is constant-power ("white") 
%                  additive noise, such as Gaussian noise
%
% uniform filter -> image smoothing
%
% laplacian filter -> image sharpening