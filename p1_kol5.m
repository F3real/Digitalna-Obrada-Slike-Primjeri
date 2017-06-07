%% task 1
% Data je slika bl_narusena.tif. Gornja i lijeva polovina slike 
% narušene su šumom razlicitih tipova. Dakle, slika je po cetvrtinama 
% narušena razlicitim tipovima šuma (donji desni dio slike nije uopšte
% narušen šumom). Napisati program u MATLAB-u koji ce uklanjati šum sa 
% slike i prikažite najbolju filtriranu sliku. Isprobajte nekoliko 
% razlicitih tipova filtara i izaberite one koji daju najbolje 
% rezultate u smislu najmanje srednjekvadratne greške koja se dobije 
% za svaki od tipova filtara u odnosu na odgovarajuci dio originalne slike 
% bl_orig.tif. Navesti dobijene srednjekvadratne greške.

a = imread('bl_narusena.tif');
org = imread('bl_orig.tif');

% part 1
a1 = a(1:256,1:256);
a1f = medfilt2(a1, 'symmetric');
a1f = wiener2(a1f, [3 3]);


er1 = immse(org(1:256,1:256),a1f);
% figure, imshow(a1, []), title('part 1 org');
% figure, imshow(a1f, []), title('part 1 fix');

% part 2
a2 = a(256:512,1:256);
a2 = im2double(a2);
a2f = wiener2(a2, [3 3]);

a2f = im2uint8(a2f);
er2 = immse(org(256:512,1:256),a2f);
%figure, imshow(a2, []), title('part 2 org');
%figure, imshow(a2f, []), title('part 2 fix');

% part 3
a3 = a(1:256,256:512);
a3f = medfilt2(a3, 'symmetric');

er3 = immse(org(1:256,256:512), a3f);
% figure, imshow(a3, []), title('part 3 org');
% figure, imshow(a3f, []), title('part 3 fix');

% making res
res(1:256,1:256) = a1f;
res(256:512,1:256) = a2f;
res(1:256,256:512)= a3f;
res(256:512,256:512)= a(256:512,256:512);

% end
%figure, imshow(a, []), title('bl_narusena org');
figure, imshowpair(org,res, 'montage');
%% task2 
% Data je narušena slika interf.tif. Napisati program u MATLAB-u za 
% uklanjanje ovog poremecaja pogodnim filtriranjem.

a = imread('interf.tif');
af = fft2(a);
aff = fftshift(af);

mag = log(1 + abs(aff));
% (137,133)

u0 = (129-137)*2/256;
v0 = (129-133)*2/256;
[U,V] = freqspace([256 256], 'meshgrid');

D0 = 0.001 ^2;
D1 = sqrt((U - u0).^2 + (V - v0).^2);
D2 = sqrt((U + u0).^2 + (V + v0).^2);

H1 = 1 ./ ( 1 + ( D0 ./ (D1 .* D2)).^ 2);

res0 = aff .* H1;
res1 = fftshift(res0);
res2 = ifft2(res1);

% (137,129)
u0 = -(129-137)*2/256;
v0 = -(129-129)*2/256;
[U,V] = freqspace([256 256], 'meshgrid');

D0 = 0.001 ^2;
D1 = sqrt((U - u0).^2 + (V - v0).^2);
D2 = sqrt((U + u0).^2 + (V + v0).^2);

H2 = 1 ./ ( 1 + ( D0 ./ (D1 .* D2)).^ 2);

res3 = aff .* H2;
res4 = fftshift(res3);
res5 = ifft2(res4);

resf = aff .* H1 .* H2;
resf1 = ifft2(fftshift(resf));

%figure, imshow(mag, []), title('interf mag'), impixelinfo;
figure, imshow(a, []), title('interf org');
%figure, imshow(res2, []), title('interf fix 1');
%figure, imshow(res5, []), title('interf fix 2');
figure, imshow(resf1, []), title('interf fix f');
%% task3
% Na raspolaganju vam je slika novcici.tif napravljena kamerom koja 
% nije adekvatno fokusirana. Medjutim, poznato je da se njen impulsni 
% odziv može modelirati funkcijom 
% h(x, y) = (1/(4 *pi)) * e^((x^2 + y^2)/4)) . 
% Koristeci adekvatne algoritme obrade slike napisati program u 
% MATLAB-u kojim ce se kvalitet slike poboljšati tako da je moguce 
% procitati vrijednosti novcica.

a = imread('novcici.tif');
af = fft2(a);
aff = fftshift(af);

[U,V] = freqspace([384 512], 'meshgrid');
H = (1 ./ (4 * pi)) * exp((U.^2 + V.^2) ./ 4);

K = 0;
H1 = conj(H) ./ (abs(H).^2 + K);
%figure, mesh(H1);
res = aff .* H1;
res1 = ifft2(fftshift(res));

%figure, imshow(a, []), title('novcici org');
figure, imshow(abs(res1), []), title('novcici fix');