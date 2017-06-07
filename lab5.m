%% task 1 2
a = 10;
b = 10;
T = 1;

[U,V] = freqspace([256 256], 'meshgrid');
sub_exp = U * a + V * b;
H =  T * sinc( pi * sub_exp) .* exp(-1i * pi * sub_exp);


lena = imread('lena.jpg');
figure, imshow(lena), title('Lena');

lena_nr = abs(ifft2( fftshift(fftshift(fft2(lena)) .* H)));
figure, imshow(lena_nr, []), title('Lena narusena');

gaus_temp = mat2gray(lena_nr);
gaus = imnoise( gaus_temp, 'gaussian', 0, 1*10^-6); 
figure, imshow(gaus, []), title('Lena noise');

% fft2 cordinate center is left upper corner
% freqspace cordinate center is middle
% ifft2 expects cordinate center in upper left
% ifft2 returns complex numbers so we need abs
% if center is not in same place we need to fftshift
%% task 3


gaus_fx0 =  fftshift(fft2(gaus)) ./ H;
gaus_fx = abs(ifft2( fftshift(gaus_fx0)));
figure, imshow(gaus_fx, []), title('Lena_3');

gaus_freq0 = fft2(gaus_fx);
gaus_freq1 = log(1 + abs(gaus_freq0));
gaus_freq2 = fftshift(gaus_freq1);
figure, imshow(gaus_freq2, []), title('Lena log'), impixelinfo;

%% task 4 5
u0 =0.24;
v0 = 0.24;
[U, V] = freqspace([256 256], 'meshgrid');

D0 = 0.3;
D02 = D0.*D0;
D1= sqrt((U - u0).^2 + (V - v0).^2);
D2= sqrt((U + u0).^2 + (V + v0).^2);

HH = 1./(1 + ((D02)./(D1.*D2)).^50);


lena_bv = ifft2(fftshift(gaus_fx0 .* HH));
figure, imshow(abs(lena_bv), []), title('Lena_bv');

%% task 6 7 8
lena = imread('lena.jpg');

K = 1*10^-6;

wiener = conj(H) ./ ( abs(H).^2 + K);

lena_nr = abs(ifft2( fftshift(fftshift(fft2(lena)) .* H)));
gaus = imnoise( mat2gray(lena_nr), 'gaussian', 0, 1*10^-6); 

gaus_w = fftshift(fft2(gaus)) .* wiener;
gaus_wf = abs(ifft2(fftshift(gaus_w)));
figure, imshow(abs(gaus_wf), []), title('Lena_w');
