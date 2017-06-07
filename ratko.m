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

K = 1*10^-3;
wiener = conj(h1)./(abs(h1).^2+K);

% apply filter
res = aff .* wiener;
res0 = fftshift(res);
res1 = ifft2(res0);

figure, imshow(a, []), title('zamucena org 3');
figure, imshow(abs(res1), []), title('zamucena fixed 3');
