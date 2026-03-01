function [ OutputImage ] = CT_CompressHDR( Params, InputImage, ImageInfo, save_results )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

Ioriginal = InputImage;
info = ImageInfo;
%closeAll = Params.closeAll;
ShowInput = Params.ShowInput;
%ShowOld = Params.ShowOld;
%ShowOutput = Params.ShowOutput;
ShowHists = Params.ShowHists;
ShowPlots = Params.ShowPlots;
%PlotR = Params.PlotR;

ShrinkFactor = Params.ShrinkFactor;

%PerformOldAlg = Params.PerformOldAlg;
PrePro = Params.PrePro;
OurPrePro = Params.OurPrePro;
PostPro = Params.PostPro;
%multipleI0 = Params.multipleI0;

saveResults = Params.saveResults;
%saveCLAHEResults = Params.saveCLAHEResults;

minOfMaxValue = Inf;
Ioriginal =    min(Ioriginal,minOfMaxValue);
Imax = max(Ioriginal(:));
I0 = (imresize(Ioriginal(:,:,1), ShrinkFactor));

[M,Ilung,Ibone] = modulation(I0);
M = 1-M;

I0 = NormAndConvertImagetoDouble(I0);
OutputImage.Original = I0;
OutputImage.CLAHE = adapthisteq(I0,'Distribution','exponential');

if(ShowInput)
    figure(100);subplot(1,2,1);
    imshow(I0,[]);
    title('Original Image ');

    figure(100);subplot(1,2,2);
    I0CLAHE = adapthisteq(I0,'Distribution','exponential');
    imshow(I0CLAHE,[]);
    title('Original Image + CLAHE ');
    OutputImage.CLAHE = I0CLAHE;

    if(ShowHists)
        figure(101);subplot(1,2,1);
        hist(I0(:));
        title('Original Image');

        figure(101);subplot(1,2,2);
        hist(I0CLAHE(:));
        title('Original Image + CLAHE ');
    end
end

if (OurPrePro)
    I0(1,1) = 0; % over exposed pixels
    I0 = I0 - I0(1, end/2); % remove air
    I0(I0 < 0) = 0;


if Params.TestPreProcessing
    for iV = 1:length(Params.Vrange)
    CurrentV =   Params.Vrange(iV);  
    AlgoParams.V = CurrentV/double(Imax);
    AlgoParams.C1  = 1.2;
    AlgoParams.C2 = 2.1;
    [ Ioutput, W_V, input_V] = StretchSoft_TestBestParamaters_ForCTImages( I0, AlgoParams);
    Ioutput(Ioutput<0) = 0;
    figure(666);
    plot(input_V.*double(Imax),W_V,'*');grid on;hold all
    if iV==length(Params.Vrange)
        legend(cellstr(num2str(Params.Vrange(:))))
    end
    figure(667);
    subplot(2,3,iV);
    imshow(Ioutput, []);
     title(num2str(Params.Vrange(iV)));
    figure(668);
    subplot(2,3,iV);
    imshow(reshape(W_V,512,512), []); 
    title(num2str(Params.Vrange(iV)));
    end
    figure(667);
    linkaxes;
    figure(668);
    linkaxes;
else
I0 = StretchSoft(I0, Imax);
I0(I0 < 0) = 0;
end

    disp('Finished Pre Processing');

end
if(PrePro)
    I0 = GainExp(I0,-2);
end

I0(imag(I0) ~= 0) = real(I0(imag(I0) ~= 0));


N=7;
gap = 1;


padFactor = 2^(N+1);
[r,c] = size(I0);
padR = 0;
padC = 0;
if(mod(r,padFactor)~=0)
    padR = padFactor - mod(r,padFactor);
end
if(mod(c,padFactor)~=0)
    padC = padFactor - mod(c,padFactor);
end

I0 = padarray(I0,[padR padC],'post');
Iorg = padarray(NormAndConvertImagetoDouble(Ioriginal),[padR padC],'post');

[BlurredPyramid]= GenerateBlurredPyramid(I0,N,gap);

[ModulationPyramid]= GenerateBlurredPyramid(M,N,gap);

[ContrastPyramid]= GenerateContrastPyramid(BlurredPyramid,N,gap);

GammaParams = Params.GammaParams;

[SorfPyramid,CenterSrndPyramid]=  GenerateSorfPyramid(BlurredPyramid,N,gap);

GammaPyrmaid = CalculteGamma(SorfPyramid,GammaParams,ContrastPyramid,ModulationPyramid);

ResponsePyramid = CalculateResponse(ContrastPyramid,GammaPyrmaid,ModulationPyramid);
[InverseContrastPyramid,ReferenceResponsePyramid] = CalculateResponseWithInverse(ContrastPyramid,GammaPyrmaid,20);

F0= CollapseResponsePyramid(ResponsePyramid,ContrastPyramid);
[max(F0(:)) min(F0(:))]

FinalImage = F0(1:end-padR,1:end-padC);

% COMPUTE STATISTICS
meanAfterHDR     = mean2(FinalImage);
stdAfterHDR      = std2(FinalImage);

targetMeanRatio = 1;
targetStdRatio  = 1;
% COMPUTE TARGET STATISTICS FOR CURRENT HDR FRAME
targetMean = meanAfterHDR*targetMeanRatio;
targetStd  = stdAfterHDR*targetStdRatio;
% TRANSFORM CONTRAST AND GAIN FOR CURRENT HDR FRAME
FinalImage = transformMeanStd(FinalImage,targetMean,targetStd);

if(~saveResults)
    imtool(FinalImage,[]);
end

if(ShowPlots)
    PlotPyramid(BlurredPyramid,'BlurredPyramid');
    PlotPyramid(ContrastPyramid,'ContrastPyramid');
    PlotPyramid(SorfPyramid,'SorfPyramid');
    PlotPyramid(GammaPyrmaid,'GammaPyrmaid');
    PlotPyramid(ResponsePyramid,'ResponsePyramid');

    HistPyramid(SorfPyramid,'SorfPyramid');
    HistPyramid(GammaPyrmaid,'GammaPyrmaid');

    PlotPyramidsGraph(ContrastPyramid,ResponsePyramid);
end

s = struct('name',Params.ImageName,'Result',FinalImage,'info',info,'max',max(FinalImage(:)));
Result = s;

if(PostPro)
    FinalImageNorm = GainExp(FinalImage./max(FinalImage(:)),-3);
    OutputImage.PostProFinalImage = FinalImageNorm;
end


%         if(saveResults)
%             %FinalImageNorm(imag(FinalImageNorm) ~= 0) = real(FinalImageNorm(imag(FinalImageNorm) ~= 0));
%             %FinalImageNorm(FinalImageNorm <0 ) = 1e-9;
%             OutputDirectoryPng = fullfile(local, savePngDirectory);
%             mkdir(OutputDirectoryPng);
%             OutputFileName = [OutputDirectoryPng '\' Files(ImageIndex).name];
%             Result = 256*(FinalImageNorm);
%             imwrite(uint8(Result),strcat(OutputFileName,'.png') , 'png');
%             Result = int16(Result);
%             info.SOPInstanceUID = dicomuid;
%             info.RescaleIntercept = 0;
%             info.WindowCenter = 146;
%             info.WindowWidth = 256;
%             %Result(imag(Result)) = real(Result);
%             OutputDirectory = fullfile(local, saveDicomDirectory);
%             mkdir(OutputDirectory);
%             OutputFileName = [OutputDirectory '\' Files(ImageIndex).name];
%             dicomwrite(Result, OutputFileName, info, 'CreateMode', 'copy');
%             %imwrite(Result, OutputFileName, 'png');
%
%
%         end

%             figure;
%             imshow(FinalImageNormCLAHE,[]);
%             figTitle = ['New + Old Alg'];
%             title(figTitle);


%     end

if(saveResults)
    fmax = max([Result.max]);
    fmedian = median([Result.max]);


    for i = 1 : size(Result,2)
        FinalImage = Result(i).Result;
        FinalImage = min(FinalImage,fmedian);
        FinalImageNorm = FinalImage./fmedian;

        Result_image = 256*(FinalImageNorm);
        OutputImage.Final = FinalImageNorm;
        Result_image = int16(Result_image);
        info_image = Result(i).info;
        info_image.SOPInstanceUID = dicomuid;
        info_image.RescaleIntercept = 0;
        info_image.WindowCenter = 128;
        info_image.WindowWidth = 256;
        OutputImage.Dicom = Result_image;

    end


end

