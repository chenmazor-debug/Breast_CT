function[Params]=LoadInitialParameters



Params.closeAll = 0;
Params.ShowInput = 1;
Params.ShowOld = 0;
Params.ShowOutput = 1;
Params.ShowHists = 1;
Params.ShowPlots = 0;
Params.PlotR = 1;

Params.ShrinkFactor = 1;

Params.PerformOldAlg = 0;
Params.PrePro = 0;
Params.OurPrePro = 1;
Params.PostPro = 0;
Params.multipleI0 = 0;


Params.saveCLAHEResults = 1;
Params.saveResults = 1;




%%FinalGainImage parameters
Params.Rmax=1.5;
Params.alpha=1.6;

%%Beliteral filter
Params.wBlurred=5;
Params.sigmaBlurred=[3,4];

Params.wHyBlurred=30;
Params.sigmaHyBlurred=[7,8];
%% Contrast Image
Params.StartLevelInput=1;
Params.EndLevelInput=6;

Params.StartLevelBlurred=2;
Params.EndLevelBlurred=5;

Params.StartLevelHyBlurred=5;
Params.EndLevelHyBlurred=6;

Params.powerFactor0=1;
Params.powerFactor1=1;
Params.powerFactor2=0.7;
Params.gainFactor0=7;
Params.gainFactor1=35;
Params.gainFactor2=5;

Params.surfPowerFactor0 = 1;
Params.surfPowerFactor1 = 1;
Params.surfPowerFactor2 = 1;
%% Top level statistical normalization
Params.Linearb=0.2;
Params.Lineara=0.3;

%% Ultra level statistical normalization
Params.Lineara_ultra = 0.8;
Params.Linearb_ultra = 0.3;

Params.UltraStatNorm = false;

%% Nirmol each of the images after the beliteral filter
Params.NirmolBlurred = 1;
Params.NirmolHyBlurred = 1;
Params.NirmolInput = 1;

%% Simple normalization factor for final image in the bw area
Params.BWnirmol = 0.27;

%% initial stretch of Input and Blurred
Params.Stretch = false;
Params.StrechBlurred = 0.36;
Params.StrechInput = 2;

%% initial preprocessing
Params.InitialMean = 0.65;

%% Gamma Params 

Params.GammaParams{1}.a = 0.7;
Params.GammaParams{2}.a = 0.7;
Params.GammaParams{3}.a = 0.7;
Params.GammaParams{4}.a = 0.7;
Params.GammaParams{5}.a = 0.7;
Params.GammaParams{6}.a = 0.7;
Params.GammaParams{7}.a = 0.7;
Params.GammaParams{8}.a = 0.7;

Params.GammaParams{1}.b = 1;
Params.GammaParams{2}.b = 1;
Params.GammaParams{3}.b = 1;
Params.GammaParams{4}.b = 1;
Params.GammaParams{5}.b = 1;
Params.GammaParams{6}.b = 1;
Params.GammaParams{7}.b = 1;
Params.GammaParams{8}.b = 1;

Params.GammaParams{1}.c = 15;
Params.GammaParams{2}.c = 15;
Params.GammaParams{3}.c = 15;
Params.GammaParams{4}.c = 15;
Params.GammaParams{5}.c = 15;
Params.GammaParams{6}.c = 15;
Params.GammaParams{7}.c = 15;
Params.GammaParams{8}.c = 15;

end

