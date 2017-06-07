%% task 1
% Prilikom skeniranja stranice ciji je dio dat na slici razv_1910.tif 
% original nije ravno postavljen u skener, pa su linije na skeniranoj 
% slici nagnute pod odredenim uglom. Napisati program u MATLAB-u koji ce 
% automatski odredivati nagib linija teksta na datoj slici.
 
a = imread('razv_1910.tif');

% [a_bl, treshold] = edge(a, 'log');
% [a_bs, treshold] = edge(a, 'Sobel');
% [a_bp, treshold] = edge(a, 'Prewitt');
% [a_br, treshold] = edge(a, 'Roberts');

figure, imshow(a), title('org');
% figure, imshow(a_bl), title('org binary log');
% figure, imshow(a_bs), title('org binary sobel');
% figure, imshow(a_bp), title('org binary prewitt');
% figure, imshow(a_br), title('org binary roberts');

a = im2double(a);
ab = im2bw(a, 0.9);
figure, imshow(ab), title('org binary');
[H, theta, rho] = hough(ab);

imshow(H, [], 'XData', theta, 'YData', rho );
xlabel('\theta'), ylabel('\rho');
axis on, axis normal;

P = houghpeaks(H,4,'threshold',ceil(0.6*max(H(:))));
hold on; 
plot( theta( P(:,2) ), rho( P(:,1) ), 's', 'color', 'green')
lines = houghlines(ab,theta,rho,P,'MinLength',20);
figure, imshow(a), hold on
for k = 1:length(lines)
    xy = [lines(k).point1; lines(k).point2];
    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
    % ozna?avanje po?etaka i krajeva linija
    plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
    plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
    atan2(xy(1,2)-xy(2,2),xy(1,1)-xy(2,2))
end

res = imrotate(a, -3.05);
figure, imshow(res), title('res');



%% task 2
% Data je slika skeniranog teksta razv_1910.tif. 
% Napisati program u MATLAB-u koji ce brojati rijeci u tekstu. 
% Može se smatrati da su velicine slova i razmaka poznate. Rijeci 
% koje dodiruju rub slike se ne broje. Tacnost rezultata ce 
% uticati na broj bodova.

a = imread('razv_1910.tif');
figure, imshow(a), title('Org');

a = im2double(a);
ab = im2bw(a, 0.9);
ab = ~ab;
ab = imclearborder(ab);
ab = imfill(ab, 'holes');
res = bwmorph(ab, 'bridge', inf);
res = bwmorph(res, 'fill', inf);
res = bwmorph(res, 'clean', inf);

[label_mat, count] = bwlabel(res);
figure, imshow(res), title('Res');
%% task 3
%Data je slika BW.bmp. Može se smatrati da su svi kvadrati iste velicine, 
%odnosno, da su svi diskovi iste velicine. Napisati program u MATLAB-u 
%koji ce automatski odredivati broj kvadrata na slici.

a = imread('BW.bmp');
ab = ~a;
figure, imshow(ab), title('Org'), impixelinfo;

se2=strel('disk',32);
abr = imopen(ab, se2);
[H, count] = bwlabel(abr);
figure, imshow(abr), title('Org');
%% task 4
%   Napisati program u MATLAB-u kojim ce se vršiti automatska 
%   segmentacija slike rukopis.tif. Dozvoljeni su predobrada i 
%   postobrada slike. Pretpostavlja se da su poznate velicine 
%   poremecaja i slova, a osim toga program ne smije da zavisi 
%   od spoljnih parametara.

a = imread('rukopis.tif');
figure, imshow(a), title('Rukopis Org');
a = im2double(a);

ab = im2bw(a, 0.15);
figure, imshow(ab), title('Rukopis Bin');

ab_r = bwmorph(ab, 'clean', inf);
ab_r = bwmorph(ab_r, 'thin');
figure, imshow(ab_r), title('Rukopis Bin Processed');

[x y p] = size(ab_r);
data = reshape(ab_r, x*y, p);
lab = kmeans(data, 2, 'Replicates', 5);
lab = reshape(lab, x, y);
figure,imshow(lab,[]);
rgb = label2rgb(lab);
figure,imshow(lab,[]);

%% task 5  meh
%Napisati program u MATLAB-u kojim ce se vršiti automatska segmentacija 
%slike jazavac_narusena.tif. Dozvoljeni su predobrada i postobrada slike. 
%Pretpostavlja se da su poznate velicine poremecaja i slova, a osim toga 
%program ne smije da zavisi od spoljnih parametara.
a = imread('jazavac_narusena.tif');
figure, imshow(a), title('Org');
a = im2double(a);
index_x = uint8(150:350);
index_y = uint8(180:250);
mask = double(a(index_x, index_y) < 0.55);
mask = mask .* 0.4;
a(index_x, index_y) = a(index_x, index_y) - mask;

ab = adapthisteq(a);
ab = im2bw(ab, 0.2);
%figure, imshow(ab), title('Org adjusted');
ab = ~ab;

ab_res = bwmorph(ab, 'clean', inf);
ab_res = imclearborder(ab_res, 8);
ab_res = bwareaopen(ab_res, 4);
%figure, imshow(ab_res), title('Org adjusted');


[x y p ] = size(ab_res);
data = reshape(ab_res,x*y,p);
data = kmeans(data, 3, 'Replicate', 10);
res = reshape(data, x, y, p);
figure, imshow(res, []), title('Res');

%% task 6
% Napisati program u MATLAB-u kojim ce se vršiti automatska segmentacija 
% slike strana.png. Dozvoljeni su predobrada i postobrada slike. 
% Pretpostavlja se da su poznate velicine poremecaja i slova, a osim toga 
% program ne smije da zavisi od spoljnih parametara.

a = imread('strana.png');
figure, imshow(a), title('Strana png');

ab = adapthisteq(a);
y = uint8(1:150);
ab(:,y) = imadjust(ab(:,y), [0.2 0.6], [0 1]);
y1 = uint8(150:384);
ab(:,y1) = imadjust(ab(:,y1), [0.2 0.6], [0 1]);
ab = im2bw(ab, 0.4);
ab = ~bwareaopen(~ab, 4);
ab = ~imclearborder(~ab);
ab = bwmorph(ab, 'clean', inf);

[x y p ] = size(ab);
data = reshape(ab,x*y,p);
data = kmeans(data, 2, 'Replicate', 10);
res = reshape(data, x, y, p);
figure, imshow(res, []), title('Res');
%% task 7
% U borbi protiv nove bakterije potrebno je segmentirati 
% mikroskopsku sliku blobz1.png. Pozadina je svijetla, a objekti od 
% interesa su tamni. Izlaz treba da bude binarna slika na kojoj su 
% logickom 1 oznaceni objekti od interesa. Dozvoljena je predobrada i 
% postobrada slike kako bi rezultati bili što bolji. Kvalitet 
% segmentacije ce uticati na ocjenu.

a = imread('blobz1.png');
figure, imshow(a), title('Image org');

a = adapthisteq(a);
a = im2bw(a,0.38);
a = ~a;
a = imfill(a, 'holes');
figure, imshow(a), title('Image processed');

%% task 8
% Napravite dio sistema za vožnju automobila koji ce detektovati 
% liniju koja dijeli trake na putu. Program testirati na slici put.jpg. 
% Izlaz iz programa je originalna slika na koju su dodate linije.

a = imread('put.jpg');
figure, imshow(a), title('Orginal');

ab = im2bw(a, 0.77);
ab = bwareaopen(ab, 4);
ab = bwmorph(ab, 'thin');
figure, imshow(ab), title('Bin');

[H theta rho] = hough(ab);
figure, imshow(H, [], 'Xdata', theta, 'Ydata', rho);
P  = houghpeaks(H, 2);
lines = houghlines(ab, theta, rho, P);

figure, imshow(a), hold on
for k = 1:length(lines)
    xy = [lines(k).point1; lines(k).point2];
    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
    % ozna?avanje po?etaka i krajeva linija
    plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
    plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
    atan2(xy(1,2)-xy(2,2),xy(1,1)-xy(2,2))
end

%% task 9
%Data je skenirana slika razv_1910_sjena.tif. Napisati program u MATLAB-u koji ce 
%automatski segmentirati datu sliku na objekte od interesa (slova) i pozadinu (papir). 
%Kvalitet segmentacije ce uticati na broj bodova.


a = imread('razv_1910_sjena.tif');
figure, imshow(a), title('Original'), impixelinfo;
a = im2double(a);
x_ind = uint8(75:115);
a(x_ind,:) = im2bw(a(x_ind,:),graythresh(a(x_ind,:)));
%figure, imshow(a), title('Bin 0');
x_ind = uint8(60:130);
a(x_ind,:) = im2bw(a(x_ind,:),0.3);
%figure, imshow(a), title('Bin 1');
x_ind = uint8(150:170);
a(x_ind,:) = im2bw(a(x_ind,:),0.7);
%figure, imshow(ab), title('Bin 2');
x_ind = uint8(190:201);
a(x_ind,:) = im2bw(a(x_ind,:),0.3);
ab = im2bw(a, 0.52);
%figure, imshow(ab), title('Bin 3');

figure, imshow(ab), title('Res');


%% task 10
%Napisati program u MATLAB-u kojim ce se vršiti automatska segmentacija 
%slike otadzbina_narusena.tif. Dozvoljeni su predobrada i 
%postobrada slike. Pretpostavlja se da su poznate velicine poremecaja 
%i slova, a osim toga program ne smije da zavisi od spoljnih parametara.

a = imread('otadzbina_narusena.tif');
a = im2double(a);
figure, imshow(a), title('Original'), impixelinfo;

x = uint16(125:380);
y = uint16(150:550);

ab = a;
ab(x,y) = im2bw(a(x,y), 0.40);


ab = adapthisteq(ab);
ab = mat2gray(ab);
ab = im2bw(ab, 0.2);
ab = ~imclearborder(~ab, 4);
ab = ~bwareaopen(~ab, 8);
figure, imshow(ab), title('Res');

[x y p] = size(ab);
data = reshape(ab, x*y, p);
res = kmeans(data, 2, 'Replicate', 10);
data_res = reshape(res, x,y,p);
figure, imshow(ab), title('Res');

%% task 11
% Odlucili ste da napravite robota koji je u stanju da igra jednostavne racunarske igrice. 
% Jedna od mogucnosti neophodnih vizuelnom sistemu Vašeg robota je 
% prepoznavanje objekata na ekranu. Napisati program u MATLAB-u koji 
% ce robotu omoguciti da na slici komsiluk.tif pronade 
% lokacije saobracajnih znakova kvadratnog oblika.
% Jedna od ideja je da se prvo detektuju i rekonstruišu kuce, a 
% zatim da se uklone sa slike. 
% Nakon toga na slici ostaju samo saobracajni znaci.

a = imread('komsiluk.tif');
a = rgb2gray(a);
a = im2double(a);
a = 1 - a;
ab = im2bw(a, 0.4);
ab = ~ab;
figure, imshow(ab), title('Original'), impixelinfo;

tmp = bwareaopen(ab, 800); %get mask for large objects
%figure, imshow(tmp), title('Original'), impixelinfo;

ab = ab - tmp; % remove houses
%figure, imshow(ab), title('Res 1'), impixelinfo;

st = strel('square', 20);
tmp = imopen(ab, st);
figure, imshow(tmp), title('Res');


%just testing part task is done
[B L] = bwboundaries(tmp);
r = regionprops(L, 'all');
for i=1:size(r)
    r(i).BoundingBox
end
%% task 12
 %Napisati program u MATLAB-u kojim ce se automatski analizirati 
 %anketni listic na slici anketa.png. Rezultat treba da budu dva 
 %niza 'predavanja' i 'vjezbe' u kojima ce se nalaziti vrijednosti 
 %pojedinih ocjena po stavkama. Smatrati da je poznata velicina 
 %popunjenog polja izražena u pikselima, da su na konkretnom uzorku 
 %zastupljene sve ocjene i za predavanja i za vježbe, te da postoje 
 %ocjene za svaku stavku
 
 
 a  = imread('anketa.png');
 %figure, imshow(a), title('Org'), impixelinfo;
 
 ab = im2bw(a, 0.8);
 %figure, imshow(ab), title('Bin');
 
 abr = bwmorph(ab, 'fill');
 
 %fill holes in full circles
 st1 = strel('disk', 2);
 abr = ~imclose(~abr, st1);
 
 %remove empty circles
 st1 = strel('disk', 8);
 abr = ~imopen(~abr, st1);
 figure, imshow(abr), title('Bin res'), impixelinfo;
 
 %create list of objects
 [B L] = bwboundaries(~abr);
 r = regionprops(L, 'all');

 vjezbe = zeros(11,1);
 predavanja = double(1:11) * 0;
 

 % we need to add cases looking at pixels for other grades and add cases
 % for lines
for i=1:size(r)
 %detect one in lectures
 if r(i).BoundingBox(1) < 766 && (r(i).BoundingBox(1) + r(i).BoundingBox(3)) > 766
     1
 end
 %detect three in lectures
 if r(i).BoundingBox(1) < 845 && (r(i).BoundingBox(1) + r(i).BoundingBox(3)) > 845
     3
 end  
end    

 %% task 13
 
 % Data je slika aerodrom2.jpg. Napisati program u MATLAB-u koji ce 
 % pronalaziti aerodromsku pistu na ovoj slici i odredivati njene 
 % pocetne i krajnje koordinate, kao i odstupanje u stepenima od 
 % vertikalne ose slike. Može se pretpostaviti da je pista prava linija 
 % i izlaz iz programa treba da budu koordinate pocetka i kraja piste, 
 % kao i vrijednost ugla odstupanja. Dozvoljeno je rucno podešavanje 
 % parametara.
 
a = imread('aerodrom2.jpg');
%figure, imshow(a), title('Original');
 
ab = rgb2gray(a);
ab = im2double(ab);
ab = 1 - ab;

abr = im2bw(ab, 0.35);
abr = ~abr;
abr = bwareaopen(abr, 10);
%figure, imshow(abr), title('Original gray');

[H theta rho] = hough(abr);
P = houghpeaks(H, 1);
L = houghlines(abr, theta, rho, P, 'MinLength', 250, 'FillGap', 80);
 
res_degree = 0;
res_start = 0;
res_end = 0;
figure, imshow(a), hold on
for k = 1:length(L)
    xy = [L(k).point1; L(k).point2];
    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
    % ozna?avanje po?etaka i krajeva linija
    plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
    plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
    
    %res_degree = atan2(xy(2,2) - xy(1,2), xy(2,2) - xy(1,1));

    res_end = [ xy(1,1), xy(1,2)];
    res_start = [ xy(2,1), xy(2,2) ];
    
    t1 = sqrt((res_end(1) - res_start(1))^2 + ((res_end(2) - res_start(2))^2));
    t2 = sqrt((res_start(1) - res_start(1))^2 + ((res_end(1) - res_start(1))^2));
 
    res_degree = acos (t2/t1);
 
end
t = radtodeg(res_degree);
resi = imrotate(a, t - 90);
figure, imshow(resi);
%% task 14
%Data je slika aerodrom.tif. Napisati program u MATLAB-u koji ce 
%pronalaziti aerodromsku pistu na ovoj slici i odredivati njene 
%pocetne i krajnje koordinate, kao i odstupanje u stepenima od 
%vertikalne ose slike. Može se pretpostaviti da je pista prava linija i 
%izlaz iz programa treba da budu koordinate pocetka i kraja piste, kao i 
%vrijednost ugla odstupanja. Dozvoljeno je rucno podešavanje parametara.

ai = imread('aerodrom.tif');
%figure, imshow(a), title('Orginal');

ai = im2double(ai);
ab = im2bw(ai, 0.20);
ab = ~ab;
ab = bwareaopen(ab, 40);
%figure, imshow(ab), title('Bin');

[H theta rho] = hough(ab);
P = houghpeaks(H, 1);
L = houghlines(ab, theta, rho, P, 'Fill', 40);
 
figure, imshow(ai), title('Res'), hold on
for k = 1:length(L)
    xy = [L(k).point1; L(k).point2];
    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
    % ozna?avanje po?etaka i krajeva linija
    plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
    plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

    res_end = [ xy(1,1), xy(1,2)];
    res_start = [ xy(2,1), xy(2,2) ];
    c = sqrt((xy(1,1)-xy(2,1))^2 + (xy(1,2)-xy(2,2))^2);
    a = sqrt((xy(2,1)-xy(2,1))^2 + (xy(1,2)-xy(2,2))^2);
    res_degree = acos(a/c);
end 

trad = rad2deg(res_degree);
tr = imrotate(ai,  -trad);
figure, imshow(tr);
%% task 15
% Data je slika bl_aerodrom.jpg. Napisati program u MATLAB-u koji ce 
% pronalaziti aerodromsku pistu na ovoj slici i odredivati njene pocetne
% i krajnje koordinate, kao i odstupanje u stepenima od vertikalne ose 
% slike. Može se pretpostaviti da je pista prava linija i izlaz iz 
% programa treba da budu koordinate pocetka i kraja piste, kao i 
% vrijednost ugla odstupanja. Dozvoljeno je rucno podešavanje parametara. 
%Slika u boji se u sivu sliku može konvertovati pomocu funkcije rgb2gray.
 
 ai = imread('bl_aerodrom.jpg');
 ai = rgb2gray(ai);
 ai = im2double(ai);
%figure, imshow(ai), title('Orginal');


ab = im2bw(ai, 0.50);
ab = bwareaopen(ab,80);
figure, imshow(ab), title('Bin');

[H theta rho] = hough(ab);
P = houghpeaks(H, 1 );
L = houghlines(ab, theta, rho, P, 'Fill', 10);
 
figure, imshow(ai), title('Res'), hold on
for k = 1:length(L)
    xy = [L(k).point1; L(k).point2];
    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
    % ozna?avanje po?etaka i krajeva linija
    plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
    plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

    res_end = [ xy(1,1), xy(1,2)];
    res_start = [ xy(2,1), xy(2,2) ];
    c = sqrt((xy(1,1)-xy(2,1))^2 + (xy(1,2)-xy(2,2))^2);
    a = sqrt((xy(2,1)-xy(2,1))^2 + (xy(1,2)-xy(2,2))^2);
    res_degree = acos(a/c);
end 

trad = rad2deg(res_degree);
tr = imrotate(ai,  -trad);
figure, imshow(tr);
 
%% task 16 meh
%Napisati program u MATLAB-u koja ce implementirati segmentaciju slike 
%pomocu rasta regiona. Ulaz su slika, pocetna binarna maska i 
%prag razlika intenziteta. Izlaz treba da bude binarna slika na kojoj 
%objekat sadrži piksele cija je apsolutna razlika intenziteta u 
%odnosu na piksele pocetne maske manja od zadatog praga T i predstavlja 
%jednu komponentu povezanosti. Demonstrati rad programa na 
%primjeru slike munja.jpg, pocetnu masku koju cine najsvjetliji pikseli 
%na slici i vrijednost praga od T=30 (za vrijednosti intenziteta 
%piksela u intervalu [0, 255]). (Moguci nacin realizacije:Formirajte prvo 
%binarnu sliku koja se sastoji od svih piksela ciji 
%intenziteti zadovoljavaju uslov, a onda zadržite samo regione koji se 
%sastoji od piksela povezanih sa pocetnim pikselima.)
clear;
a = imread('munja.jpg');
figure, imshow(a), title('Org');
T = 30;

max_val = max(a(:));
mask = uint8(ones(size(a)));
mask = mask .* (max_val - T);

rtemp = imsubtract(a, mask);
rtemp = uint8(rtemp > 0);

res = a .* rtemp;
figure, imshow(res), title('Res');
%% task 17
% % Data je slika pcb1.tif. Napisati program u MATLAB-u koji ce
% % pronalaziti elemente štampane veze: krugove, kvadrate, pravougaonike,
% % debele i tanke veze. Rezultat treba da budu binarne slike na kojima
% % su prikazani samo detektovani elementi. Smatrati da su dimenzije 
% % elemenata poznate. Mala odstupanja oblika se smiju zanemariti. 
% % Rupice u štampanoj vezi nisu od interesa.
clear;

a = imread('pcb1.tif');
%figure, imshow(a), title('Original'), impixelinfo;

ab = imfill(a, 'holes');
%figure, imshow(ab), title('Processed');

%find rectangles
st_rect = strel('rectangle', [14 30]);
im_rect = imopen(ab, st_rect);
ab_rect = im_rect & a;
%figure, imshow(ab_rect), title('Rectangle');

%find squares
tmp = ab - im_rect;
st_square = strel('square', 17);
im_square = imopen(tmp, st_square);
ab_square = im_square & a;
%figure, imshow(ab_square), title('Square');

%find circles
tmp = tmp - im_square;
st_disk = strel('disk', 8);
im_disk = imopen(tmp, st_disk);
ab_disk = im_disk & a;
%figure, imshow(ab_disk), title('Circle');

%find thikc lines
tmp = tmp - im_disk;
tmp = bwareaopen(tmp, 60);
im_fline = imopen(tmp, ones(5));
im_fline = bwareaopen(im_fline, 40);
%figure, imshow(im_fline), title('Thick lines');

%find thin lines
tmp  = tmp - im_fline;
im_tline = imopen(tmp, ones(2));
im_tline = bwareaopen(im_tline, 60);
%figure, imshow(im_tline), title('Thin lines');

figure,
subplot(2,3,1), imshow('pcb1.tif'), title('Org');
subplot(2,3,2), imshow(im_fline), title('Thick lines');
subplot(2,3,3), imshow(im_tline), title('Thin lines');
subplot(2,3,4), imshow(ab_disk), title('Circles');
subplot(2,3,5), imshow(ab_square), title('Squares');
subplot(2,3,6), imshow(ab_rect), title('Rectangles');

%% task 18 meh
%Data je slika razv_1910.tif. Napisati program u MATLAB-u koji ce odredivati broj pasusa 
%u tekstu i broj rijeci u svakom od pasusa. 
%Može se smatrati da su velicine slova i razmaka poznate. Rijeci koje dodiruju rub slike 
%se ne broje. Tacnost rezultata ce uticati na broj bodova.

a = imread('razv_1910.tif');
%figure, imshow(a), title('Org');


ab = im2bw(a,0.9);
ab = ~ab;
figure, imshow(ab), title('Bin');

st = strel('square', 8);
ab = imclose(ab, st);
figure, imshow(ab), title('Bin');

%% task 19 meh
% Napisati program u MATLAB-u za izdvajanje ivica sa slike metar2.jpg. 
%Rezultat treba da bude binarna mapa ivica sa vrijednošcu 1 na mjestu gdje se 
%nalazi ivica i 0 drugdje. Upotreba funkcije edge nije dozvoljena. 
%Dozvoljena je predobrada i postobrada slike kako bi rezultati bili što bolji.
clear;
a = imread('metar2.jpg');

ar = imfilter(a, fspecial('average'));
ar = ar - imfilter(ar, fspecial('laplacian'));
ar = im2double(ar);
ar = imadjust(ar, [0.5 0.85], [0 1]);
ar = im2uint8(ar);
figure,
subplot(1,2,1), imshow(a), title('Org');
subplot(1,2,2), imshow(ar), title('After filtering');
%%
fs1 = [ 1 0 -1; 2 0 -2; 1 0 -1];
fs2 = [ 1 2 1; 0 0 0; -1 -2 -1];

fp1 = [ 1 0 -1; 1 0 -1; 1 0 -1];
fp2 = [ 1 1 1; 0 0 0; -1 -1 -1];

g1 = imfilter(ar,fp1);
g2 = imfilter(ar,fp2);

figure,
subplot(1,2,1), imshow(g1, []), title('x');
subplot(1,2,2), imshow(g2, []), title('y');

g1 = im2bw(g1, 0.1);
g2 = im2bw(g2, 0.1);
ab = g1 & g2;
figure, imshow(ab), title('Bin comb');
%%

















































































 