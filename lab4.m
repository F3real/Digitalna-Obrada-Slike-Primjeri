%Sliku možemo posmatrati kao funkciju od dvije promjenljive 
%a(x,y) gdje je a amplituda(svjetlina) slike u ta?ki sa koordinatama (x,y). 
% Prema tome, i dvodimenzionalna Furijeova transformacija ove funkcije je 
%tako?e (kompleksna) funkcija od dvije promjenljive A(u,v).

%% task 1

h = zeros(256);
h(125:132, 125:132) = 1;

figure, mesh(h), title('Square kernel');
figure, imshow(h), title('Square kernel');
%% task 2 3 4
h = zeros(256);
h(125:132, 125:132) = 1;

% amplitudes can be either positive or negative. The magnitude of a 
% variable, on the other hand, is the measure of how far, 
% regardless of direction, its quantity differs from zero

% DC component, DC offset, or DC coefficient is the mean value
h = h - mean(h(:)); % removes DC component

y = abs(fft2(h));

figure, mesh(y), title('Square kernel fft');
figure, imshow(y), title('Square kernel fft'), colorbar;


yc = fftshift(abs(fft2(h))); %magnitude spectrum of the image

figure, mesh(yc), title('Square kernel fft centered');
figure, imshow(yc), title('Square kernel fft centered'), colorbar;

s = log(1 + abs(yc));
figure, imshow(y), title('Square kernel freq log'), colorbar;

%% task 5

a = imread('lena.jpg');
afft2 = fft2(a);

a_mag = fftshift(abs(afft2));
a_mag_log = log(1 + abs(a_mag));
figure, mesh(a_mag), title('Lena centered magnitude');
figure, imshow(a_mag_log, []), title('Lena centered magnitude');

a_freq_t = fftshift(afft2);
a_freq = angle(a_freq_t);
figure, imshow(a_freq, []), title('Lena centered freq');
%% task 6
a = imread('lena.jpg');
afft2 = fft2(a);

a_mag = abs(afft2);
a_mag2 = ifft2(afft2);
figure, imshow(a_mag2, []), title('Lena mag ifft2');

a_freq = angle(afft2);
a_freq3 = exp(1j.*a_freq);
a_freq4  = ifft2(a_freq);
figure, imshow(abs(a_freq4), []), title('Lena freq ifft2');

%% task 7
a = imread('lena.jpg');

u11 = fspecial('average',[11 11]);

afft2 = fft2(a);
u11fft2 = fft2(u11, 256, 256);
res = afft2 .* u11fft2; %applying filter in freq domain

r = ifft2(res);
figure, imshow(r, []), title('Lena fft2');

as = imfilter(a, u11);
figure, imshow(as, []), title('Lena u11');

%% task 8
a = imread('lena_em_interference.jpg');

af = fft2(a);
as = fftshift(log(1 + abs(af)));

% by looking at picture we can see white dots at (97,97) and (161,161)
figure, imshow(as/as(129,129), []), title('Lena log'), impixelinfo;
figure, imshow(a, []), title('Lena org');


dot1 = sqrt((97-129).^2+(97-129).^2);
dot2 = sqrt((161-129).^2+(161-129).^2);

%% notch
a = imread('lena_em_interference.jpg');
af = fft2(a);
aff = fftshift(af);

aff(:,97) = 0;
aff(97,:) = 0;
aff(:,161) = 0;
aff(161,:) = 0;

aff2 = ifft2(fftshift(aff));
figure, imshow(abs(aff2), []), title('Lena notch'), impixelinfo;

%% task 9 10
a = imread('lena_em_interference.jpg');
af = fft2(a);
aff = fftshift(af);

u0 =0.28;
v0 = 0.28;

[U, V] = freqspace([256 256], 'meshgrid');


D0 = 0.4;
D02 = D0.*D0;
D1= sqrt((U - u0).^2 + (V - v0).^2);
D2= sqrt((U + u0).^2 + (V + v0).^2);

HH = 1./(1 + ((D02)./(D1.*D2)).^2);


a_notch = ifft2(fftshift(aff .* HH));
figure, imshow(abs(a_notch), []), title('Lena notch'), impixelinfo;
figure, imshow(a, []), title('Lena org');
