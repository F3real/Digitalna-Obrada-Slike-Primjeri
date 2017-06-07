% task 1
% Vaš prijatelj zaposlen u policiji Vas ponovo moli za pomoc. Ovaj put je 
% registarska oznaka na slici auto.tif necitljiva. 
% Pogodnom obradom slike omogu?ite organima za sprovo?enje reda da 
% pro?itaju registarsku oznaku.

a = imread('auto.tif');
figure, imshow(a, []), title('auto org'), impixelinfo;

a1 = imadjust(a ,[0 0.1], [0 1], 1);
figure, imshow(a1, []), title('auto fix'), impixelinfo;

%% task 2
% Stekli ste novog prijatelja koji je radiolog. On Vas moli da uklonite 
% prostorno zavisan poremecaj sa slike HeadCT.tif.
a = imread('HeadCT.tif');

af = fft2(a);
aff = fftshift(af);

al = log(1 + abs(aff));
% (321,225) (297,297)

% first filter
u0 = -(257 - 321)*2 / 512;
v0 = -(257 - 225)*2 / 512;

[U, V] = freqspace([512 512], 'meshgrid');

D0 = 0.3 ^ 2;
D1 = sqrt( (U - u0).^2 + (V - v0).^2);
D2 = sqrt( (U + u0).^2 + (V + v0).^2);

H1 = 1 ./ ( 1 + ( D0 ./(D1 .* D2)).^2);

res0 = aff .* H1;
res1 = fftshift(res0);
res2 = ifft2(res1);
%figure, imshow(log(1 + abs(res0)), []), title('head mag'), impixelinfo;
% second filter
u0 = (257 - 297)*2 / 512;
v0 = (257 - 297)*2 / 512;

[U, V] = freqspace([512 512], 'meshgrid');

D0 = 0.1 ^ 2;
D1 = sqrt( (U - u0).^2 + (V - v0).^2);
D2 = sqrt( (U + u0).^2 + (V + v0).^2);

H2 = 1 ./ ( 1 + ( D0 ./(D1 .* D2)).^2);

res3 = aff .* H2;
res4 = fftshift(res3);
res5 = ifft2(res4);

resf = aff .* H2 .* H1;
resf1 = fftshift(resf);
resf2 = ifft2(resf1);

%figure, imshow(al, []), title('head mag'), impixelinfo;
figure, imshow(a, []), title('head org'), impixelinfo;
%figure, imshow(res2, []), title('head fix 1'), impixelinfo;
%figure, imshow(res5, []), title('head fix 2'), impixelinfo;
figure, imshow(resf2, []), title('head fix f'), impixelinfo;

%% task 3
% Implementirati filtar koji izracunava gradijent slike test.tif u 
% Furijeovom domenu.

a = imread('test.tif');

af = fft2(a);
aff = fftshift(af);

am = abs(aff);
afreq = angle(aff);

ams = ifft2(fftshift(am));
figure, imshow(a, []), title('test org'), impixelinfo;
figure, imshow(log(1+ am), []), title('test magnitude'), impixelinfo;
figure, imshow(afreq, []), title('test angle'), impixelinfo;
figure, imshow(ams, []), title('test mag'), impixelinfo;
