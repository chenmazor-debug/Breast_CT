brightnessScales = int8([2;3;5;7;9]);
brightnessMasks = ImageForces.BRIGHTNESS.CreateBrightnessMultiScaleMasks(brightnessScales);

localBrightnessDiameter = int8(10);
localBrightnessArea = ImageForces.Masks.MaskAreas.RectangularUniformArea(localBrightnessDiameter);
localBrightnessMaskFunction = ImageForces.Masks.MaskFunctions.ExponentMaskFunctionGenerator(double(localBrightnessDiameter)/2);
localBrightnessMask = ImageForces.Masks.CreateFunctionMask(localBrightnessArea,localBrightnessMaskFunction,true);

image = ones(50);
brightnessImage = [];
brightnessImage.image = image;
brightnessImage.imageLocalBrightnessBoundryBehaviour = ImageForces.Enums.ImageBoundryBehaviour.symmetric;
brightnessImage.imageScaleBrightnessBoundryBehaviour = ImageForces.Enums.ImageBoundryBehaviour.circular;
localBrightnessFunction = ImageForces.BRIGHTNESS.LocalBrightnessFunctions.AverageFunctionGenerator({});
brightnessResponse = ImageForces.BRIGHTNESS.LocalBrightnessResponse(brightnessImage, brightnessMasks, localBrightnessFunction,{});

assert(isequal(size(brightnessResponse), size(image)),strcat(mfilename(),' failed'));
imagesc(brightnessResponse);
disp(strcat(mfilename(),' passed'));