%% task 1
% Ukloniti prostorno zavisan poremecaj sa slike bl_narusena3.tif.

a = imread('bl_narusena3.tif');
af = fft2(a);
aff = fftshift(af);

mag = abs(aff);
mag_log = log(1 + mag);

% (310,300) (277,197)
[U, V] = freqspace([512 512], 'meshgrid');
u0 = (257-310)*2 /(512);
v0 = (257-300)*2 /(512);

D0 = 0.2;
D02 = D0.*D0;
D1= sqrt((U - u0).^2 + (V - v0).^2);
D2= sqrt((U + u0).^2 + (V + v0).^2);

h = 1 ./ (1 + ((D02)./(D1.*D2)).^2);

%applying filter
res0 =  aff .* h;
res1 = ifft2(fftshift(res0));

[U, V] = freqspace([512 512], 'meshgrid');
u1 = -(257-277)*2 /(512);
v1 = -(257-197)*2 /(512);

D0 = 0.04;
D02 = D0.*D0;
D1= sqrt((U - u1).^2 + (V - v1).^2);
D2= sqrt((U + u1).^2 + (V + v1).^2);

h1 = 1./(1 + ((D02)./(D1.*D2)).^2);

%applying filter
res2 =  (aff .* h) .* h1;
res3 = ifft2(fftshift(res2));

figure, imshow(mat2gray(mag_log)), title('narusena mag log'), impixelinfo;
%figure, imshow(mag, []), title('narusena mag'), impixelinfo;
figure, imshow(a), title('narusena org');

%figure, imshow(abs(res1), []), title('narusena fixed 1 ');
figure, imshow(abs(res3), []), title('narusena fixed 3');

%% task 2
% Prilikom aero-snimanja jedne scene došlo je do zamucenja slike 
% usljed pomjeranja kamere, zamucena.tif. Srecom, uslove akvizicije 
% slike je moguce ponoviti i ref.tif je snimak vrlo malog objekta 
% (može se pretpostaviti da je njegova velicina jedan piksel) 
% napravljen na potpuno isti nacin. Na osnovu raspoloživih podataka 
% restaurirati datu sliku.

a = imread('zamucena.tif');

af = fft2(a);
aff = fftshift(af);

h = imread('ref.tif');
h1 = fft2(h);
h2 = fftshift(h1);

K = 20;
wiener = conj(h2)./(abs(h2).^2+K);

% apply filter
res = aff .* wiener;
res0 = fftshift(res);
res1 = ifft2(res0);
res1 = fftshift(res1);

%figure, imshow(a, []), title('zamucena org 3');
figure, imshow(abs(res1), []), title('zamucena fixed 3');

%% task 3
% Rentgenske slike su tipicno pomalo zamucene zato što rentgenske zrake 
% nije moguce fokusirati kao svjetlosne. Popravite izgled slike 
% pluca.tif korištenjem adekvatne obrade.
% Napomena: Moguce je da slika u bilo kojem zadatku sadrži više od 
% jednog poremecaja.

a = imread('pluca.tif');
figure, imshow(a, []), title('pluca org 3');

a1 = medfilt2(a, [3 3], 'symmetric');
%figure, imshow(a1, []), title('pluca med 3');

fl = fspecial('laplacian');
a2 = imfilter(a1, fl, 'replicate');
a3 = imsubtract(a1,a2);
figure, imshow(a3, []), title('pluca sharp 3');

a4 = imadjust(a3, [0 1], [0 1], 0.7);
figure, imshow(a4, []), title('pluca end 3');