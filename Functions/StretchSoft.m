function [ output ] = StretchSoft( input,Imax)
W = zeros(size(input));
%Imax = max(input(:));

% calc center , srnd, remote
Levels = [3 7 3 7];%[3 27 9 18]; %[3 9 3 5];;
CenterSize = Levels(1);
SrndSize = Levels(2);
CenterSigma = Levels(3);
SrndSigma = Levels(4);
GaussFilterCenter = fspecial('gaussian', CenterSize, CenterSigma);
mask = padarray( ones(size(GaussFilterCenter)),[SrndSize-2*CenterSize SrndSize-2*CenterSize]);
%GaussFilterRemote = fspecial('gaussian', SrndSize, SrndSigma).*~mask;

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
%input = input.*exp( 11*(Center.^3).*(1-Remote));
% input = input - 30*(Center.^7).*((1-Remote).^3);
% input = Normal(input);

Imean = mean(input(bw));

% for (i = 1:size(input, 1))
%     for (j = 1:size(input,2))
%         W(i,j) = PieceWiseLinear(input(i,j), Imax, Imean);
% %         W(i,j) = SineStretch(input(i,j),a,b );
%     end
% end




%V =   400/double(Imax);
V =   435/double(Imax);


C1 = 7.875;%5;
C2 = 1.5; %8;

%if (input > V) 
    W1 = 4*C1.*(input.*(input > V) - V).*(1 - input.*(input > V))./((1 - V).^2);
%else
    W2 =  -4*C2.*(V-input.*(input <= V)).*input.*(input <= V)./(3*V.^2);
%end

W = W1.*(input > V) + W2.*(input <= V);

%% Understand the Weight Functiobn

W_all = W(:);
input_all = input(:);
figure(200);
plot(input_all.*double(Imax), W_all,'*');grid on;
title("Weight As A Function Of Intensity")
xlabel('I');ylabel('Weight Function');hold all;
% legend('V=950','V=1300','V=800');

%Remote = CalculateLocalContrastNewSorf_yael(input,5,6);
% V = 0.47
% sigma = 0.1;
% Remote = Remote.*exp(-(input - V).^2/sigma);

% no need to strech the lung area
% tau = 0.1; % Original paramater by hadar 
tau = 0.1; % New Paramater by Michael 
% tau = 0.5;
DieFunc = (1 - exp(-(imfilter(input,GaussFilterCenter,'replicate')).^2.5/tau));

output = ((input).^0.7 + 1.7.*DieFunc.*W.*Remote/max(Remote(:)));

% output = ((input) + W.*Remote/max(Remote(:)));


% output = Normal(output);
% output = output.*exp( + 2*(Center.^3).*(1-Remote));
%output = output + 5*(Center.^7).*(1-Remote);
end

