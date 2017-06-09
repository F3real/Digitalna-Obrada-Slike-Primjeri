%% task 1
% Poboljšati vizuelni kvalitet slike circuit1.tif uklanjanjem poreme?aja 
% kojima je narušena

a = imread('circuit1.tif');

% remove salt and pepper noise
a_fix = medfilt2(a, 'symmetric');

% equalise histogram
a_eq = histeq(a_fix, 256);

figure, imshow(a), title('Circuit orginal');
figure, imshow(a_fix), title('Circuit salt and pepper noise removed');
figure, imshow(a_eq), title('Circuit noise remove and equilased');

%% task 2
% Pogodnom obradom poboljšati sliku blx.jpg.
a = imread('blx.jpg');

% remove salt and pepper noise
a_fix = medfilt2(a, 'symmetric');

% remove periodic noise

af = fft2(a_fix);
aff = fftshift(af);

mag = log(1 + abs(aff));
% (300, 290)

[U V] = freqspace([512 512], 'meshgrid');
u0 = (257-300)*2 / 512;
v0 = (257-290)*2 / 512;

D0 = 0.05 ^ 2;
D1 = sqrt( (U - u0).^2 + (V - v0).^2 );
D2 = sqrt( (U + u0).^2 + (V + v0).^2 );

H = 1 ./ (1  + ( D0 ./ (D1 .* D2)).^2);

res = aff .* H;
res1 = fftshift(res);
res2 = ifft2(res1);

figure, imshow(mat2gray(mag)), title('blx magnitude'), impixelinfo;
figure, imshow(a), title('blx orginal');
figure, imshow(a_fix), title('blx salt and pepper noise removed');
figure, imshow(res2, []), title('blx periodic noise removed + s &p removed');

%% task 3
% Aero-snimak blxx.jpg zamu?en je usljed kretanja. 
% Isto kretanje na slici koja sadrži samo jedan piksel proizvodi efekat 
% prikazan na slici ref.jpg. Na osnovu ove informacije ukloniti zamu?enje 
% sa datog aero-snimka.

a = imread('blxx.jpg');

af = fft2(a);
aff = fftshift(af);

b = imread('ref.jpg');
bf = fft2(b);
bff = fftshift(bf);

K = 18^4;
H = conj(bff) ./ ( abs(bff).^2 + K);

res = aff .* H;
res1 = fftshift(res);
res2 = ifft2(res1);

figure, imshow(a), title('blxx orginal');
figure, imshow(mat2gray(res2), []), title('blxx fixed');