%% task 1 2

a = imread('pout.tif');
figure, imshow(a), title('Pout'), impixelinfo;
figure, imhist(a);


%% task 3
a = imread('pout.tif');
a = im2double(a);

% [] assumes [0 1]
% img given as argument must be double
a = imadjust(a, [0.3 0.65], []);
figure, imshow(a), title('Pout adjusted'), impixelinfo;
figure, imhist(a);

%% task 4
a = imread('cameraman.tif');
a = im2double(a);

figure, imshow(a), title('Camerman tif'), impixelinfo;
figure, imhist(a);
%% task 5
a = imread('cameraman.tif');
a = im2double(a);
a = imadjust(a, [0.4 0.7], [0.5, 1]);
figure, imshow(a), title('Camerman adjusted'), impixelinfo;
figure, imhist(a);

%% task 6
a = imread('cameraman.tif');
a = 255-a;
figure, imshow(a), title('Camerman negative'), impixelinfo;

%% task 7
a = imread('cameraman.tif');
a = im2double(a);
figure, imshow(a), title('Camerman'), impixelinfo;
a1 = imadjust(a, [], [], 0.5);
figure, imshow(a1), title('Camerman adjusted 0.5'), impixelinfo;
a2 = imadjust(a, [], [], 1.5);
figure, imshow(a2), title('Camerman adjusted 1.5'), impixelinfo;

%% task 8
a = imread('cameraman.tif');
a1 = histeq(a,256);
figure, imshow(a1), title('Camerman adjusted histeq'), impixelinfo;

%% task 9
a = imread('cameraman.tif');
p = imhist(a, 256) / numel(a); % normalized histogram
t1 = cumsum(p);
figure, plot((0:255)/255, t1);

[b, t2] = histeq(a, 256);
figure,plot((0:255)/255, t2);

t22 = t2(b+1);
figure, imshow(t22), title('Camerman histeq'), impixelinfo;

%% task 10
a = imread('cameraman.tif');
ad = im2double(a);
for i=1:254
    for j=1:254
        p = imhist(ad(i:i+2,j:j+2), 256) / 9;
        t = cumsum(p);
        at = t(a(i:i+2,j:j+2)+1);
        ad(i+1,j+1) =  at(2,2);
        %ad(i:i+2,j:j+2) = t(a(i:i+2,j:j+2)+1);
    end
end
figure, imshow(a), title('Camerman'), impixelinfo;
figure, imshow(ad), title('Camerman local histeq'), impixelinfo;

%% task 10