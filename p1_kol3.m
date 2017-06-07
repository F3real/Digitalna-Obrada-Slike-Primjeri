% Transformacije intenziteta piksela (operacije nad histogramom) se 
% prakticno specificiraju korištenjem look-up tabela. 
% Look-up tabela ima onoliko stavki koliko postoji razlicitih nivoa 
% intenziteta na ulaznoj slici. Svaka stavka u look-up tabeli je nova 
% vrijednost intenziteta. Napisati funkciju O = applyLUT(I, LUT) 
% ce biti implementirana transformacija intenziteta piksela pomo?u look-up 
% tabele. Argument I je ulazna grayscale slika, LUT je look-up tabela
% zadata kao vektor sa 256 elemenata, a O je izlazna grayscale slika. 
% Testirati funkciju na slici polen.jpg i sa LUT kojom je predstavljena 
% transformacija intenziteta piksela na slici data jednacinom 
% O(i,j)=round(cln(I(i,j)+1)).


c = 2;
f = round(c *log(1:255 + 1));

a = imread('polen.jpg');
b = zeros(500);

s = size(a);
for i = 1:s(1)
    for j = 1:s(2)
        b(i,j) = f(a(i,j));
    end
end

figure, imshow(a, []), title('polen org'), impixelinfo;
figure, imshow(b, []), title('polen new'), impixelinfo;

%% task 2
% Ukloniti prostorno zavisan poremecaj sa slike astro_narusena.jpg.
a = imread('astro_narusena.jpg');

af = fft2(a);
aff = fftshift(af);

al = log(1 + abs(aff));
figure, imshow(al, []), title('astro_narusena mag'), impixelinfo;
figure, imshow(a, []), title('astro_narusena org'), impixelinfo;

%(363,353)
[U, V] = freqspace([684 684], 'meshgrid');

u0 = (343-363)*2/684;
v0 = (343-353)*2/684;
D0 = 0.01 ^ 2;
D1 = sqrt( (U - u0).^2 + (V - v0).^2);
D2 = sqrt( (U + u0).^2 + (V + v0).^2);

H = 1 ./ ( 1 + (D0 ./ (D1 .* D2)).^2);

res = aff .* H;
res0 = fftshift(res);
res1 = ifft2(res0);
res2 = abs(res1);

figure, imshow(res2, []), title('astro_narusena fix'), impixelinfo;

%% task 3
% Poboljšati oštrinu slike mjesec.tif filtriranjem u frekvencijskom 
% domenu filtrom kojim se naglašavaju visoke frekvencije cija je funkcija 
% prenosa data sa: H(u,v)= 2 -  e^ -(D^2(u,v)/2*D0^2).

a = imread('mjesec.tif');

af = fft2(a);
aff = fftshift(af);

mag = log(1 + abs(aff));
% figure, imshow(a, []), title('mjesec org'), impixelinfo;
% figure, imshow(mag, []), title('mjesec mag'), impixelinfo;

[U, V] = freqspace([540 466], 'meshgrid');

H = 2 - exp(1);
