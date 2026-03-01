relativeBrightnessScales = int8([1,3;3,9;5,15;7,21]);
relativeBrightnessMasks = ImageForces.RELATIVEBRIGHTNESS.CreateRelativeBrightnessMultiScaleMasks(relativeBrightnessScales);

localRelativeBrightnessDiameter = int8(10);
localRelativeBrightnessArea = ImageForces.Masks.MaskAreas.RectangularUniformArea(localRelativeBrightnessDiameter);
localRelativeBrightnessMaskFunction = ImageForces.Masks.MaskFunctions.ExponentMaskFunctionGenerator(double(localRelativeBrightnessDiameter)/2);
localRelativeBrightnessMask = ImageForces.Masks.CreateFunctionMask(localRelativeBrightnessArea,localRelativeBrightnessMaskFunction,true);

image = ones(50);
relativeBrightnessImage = [];
relativeBrightnessImage.image = image;
relativeBrightnessImage.imageLocalRelativeBrightnessBoundryBehaviour = ImageForces.Enums.ImageBoundryBehaviour.symmetric;
relativeBrightnessImage.imageScaleRelativeBrightnessBoundryBehaviour = ImageForces.Enums.ImageBoundryBehaviour.circular;
localRelativeBrightnessFunction = ImageForces.RELATIVEBRIGHTNESS.LocalRelativeBrightnessFunctions.AverageFunctionGenerator({});
localBrightnessResponse = ImageForces.RELATIVEBRIGHTNESS.LocalRelativeBrightnessResponse(relativeBrightnessImage, relativeBrightnessMasks, localRelativeBrightnessFunction,{});

assert(isequal(size(localBrightnessResponse), size(image)),strcat(mfilename(),' failed'));
imagesc(localBrightnessResponse);
disp(strcat(mfilename(),' passed'));