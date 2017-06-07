%% task 1
%Poboljšati vizuelni kvalitet slike cetiri.tif

a = imread('cetiri.tif');
a = im2double(a);

f = fspecial('laplacian');

af = imfilter(a, f, 'replicate');
aff = imsubtract(a,af);

figure, imshow(a), title('Cetiri org');
figure, imshow(aff), title('Cetiri fixed');

%% task 2
%Ukloniti prostorno zavisan poremecaj sa slike ortofoto.tif
a = imread('ortofoto.tif');

af = fft2(a);
afs = fftshift(af);

afsl = log(1 + abs(afs));

figure, imshow(a), title('ortofoto org');
figure, imshow(afsl, []), title('ortofoto org'), impixelinfo;

% (65,65) (193,193)
% (120, 138) (138,120) applying notch
afs_1 = afs;

afs_1(65,65) = 0;
afs_1(193,193) = 0;
afs_1(120,138) = 0;
afs_1(138, 120) = 0;



afs_11 = ifft2(fftshift(afs_1));
afs_111 = abs(afs_11);
figure, imshow(afs_11, []), title('ortofoto fixed 1');

afsl_1 = log(1 + abs(afs_1));
figure, imshow(afsl_1, []), title('ortofoto fixed freq'), impixelinfo;

%% 
a = imread('ortofoto.tif');

af = fft2(a);
afs = fftshift(af);

% (193,193)

[U, V] = freqspace([256 256], 'meshgrid');
u0 = (193-129) /(256);
v0 = (193-129) /(256);

u0 = (129-193)*2 /(256);
v0 = (129-193)*2 /(256);

D0 = 0.3;
D02 = D0.*D0;
D1= sqrt((U - u0).^2 + (V - v0).^2);
D2= sqrt((U + u0).^2 + (V + v0).^2);

h = 1./(1 + ((D02)./(D1.*D2)).^2);

%applying filter 1
res0 =  afs .* h;
res1 = ifft2(fftshift(res0));

% (138,120)
u0 = -(129-138)*2 /(256);
v0 = -(129-120)*2 /(256);

D0 = 0.001;
D02 = D0.*D0;
D1= sqrt((U - u0).^2 + (V - v0).^2);
D2= sqrt((U + u0).^2 + (V + v0).^2);

h1 = 1./(1 + ((D02)./(D1.*D2)).^2);

%applying filter 2
res2 =  afs .* h .* h1;
res3 = ifft2(fftshift(res2));

figure, imshow(a), title('ortofoto org');
%figure, imshow(abs(res1), []), title('ortofoto fixed 1');
figure, imshow(abs(res3), []), title('ortofoto fixed 2');


%% task 3
% U jednoj istrazi policija ima fotografiju registarske tablice na sumnjivom 
% automobilu (tablica.tif) dobijenu pokvarenom kamerom kojom je nemoguce 
% izoštriti sliku. Vaš prijatelj koji radi u policiji je gledao CSI i 
% zakljucio da cete Vi metodama digitalne obrade slike moci da poboljšate tu 
% sliku nakon cega ce biti moguce procitati registarski broj automobila. 
% Srecom, policija je došla u posjed pokvarene kamere i Vi ste pomocu nje 
% fotografisali jedan bijeli piksel na crnoj pozadini što je dalo rezultat 
% na slici imp.tif. Iskoristite raspoložive informacije i 
% poboljšajte sliku kako bi se mogao procitati registarski broj automobila.


a = imread('tablica.tif');
b = imread('imp.tif');

af = fft2(a);
aff = fftshift(af);

K = 1000000;
H0 = fft2(b);
H1 = fftshift(H0);

wiener = conj(H1) ./ ( abs(H1).^2 + K);

res = aff .* wiener;
res1 = fftshift(res);
res2 = ifft2(res1);

% why is this needed
res2 = fftshift(res2);

%figure, imshow(a, []), title('tablica org'), impixelinfo;
%figure, imshow(b, []), title('imp org'), impixelinfo;
figure, imshow(abs(res2), []), title('tablica fixed'), impixelinfo;
