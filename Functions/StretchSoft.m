function [ output ] = StretchSoft( input,Imax)
W = zeros(size(input));

% calc center , srnd, remote
Levels = [3 7 3 7];%[3 27 9 18]; %[3 9 3 5];;
CenterSize = Levels(1);
SrndSize = Levels(2);
CenterSigma = Levels(3);
SrndSigma = Levels(4);
GaussFilterCenter = fspecial('gaussian', CenterSize, CenterSigma);
mask = padarray( ones(size(GaussFilterCenter)),[SrndSize-2*CenterSize SrndSize-2*CenterSize]);

GaussFilterRemote = fspecial('gaussian', SrndSize, SrndSigma);

GaussFilterRemote = GaussFilterRemote/sum(GaussFilterRemote(:));
Remote =  imfilter(input,GaussFilterRemote,'replicate');
Remote5 = Remote.^3;

Center = imfilter(input,GaussFilterCenter,'replicate');

% find treshold for mean calculation

level = graythresh(Center);
bw = im2bw(Center,level);
bw = bwareaopen(bw, 50);

% reduce areas with very high contrast (bones near lungs) so algorithm
% wouldn't kill them
input = input.*exp( - 2*(Center.^3).*(1-Remote));

Imean = mean(input(bw));

V =   435/double(Imax);

C1 = 7.875;
C2 = 1.5; 

W1 = 4*C1.*(input.*(input > V) - V).*(1 - input.*(input > V))./((1 - V).^2);
W2 =  -4*C2.*(V-input.*(input <= V)).*input.*(input <= V)./(3*V.^2);

W = W1.*(input > V) + W2.*(input <= V);

%% Understand the Weight Functiobn

W_all = W(:);
input_all = input(:);
figure(200);
plot(input_all.*double(Imax), W_all,'*');grid on;
title("Weight As A Function Of Intensity")
xlabel('I');ylabel('Weight Function');hold all;


% no need to strech the lung area
tau = 0.1;  
DieFunc = (1 - exp(-(imfilter(input,GaussFilterCenter,'replicate')).^2.5/tau));

output = ((input).^0.7 + 1.7.*DieFunc.*W.*Remote/max(Remote(:)));

end

