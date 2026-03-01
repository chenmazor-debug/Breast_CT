sorfScales = int8([1,3;3,9;5,15;7,21]);
sorfMasks = ImageForces.SORF.CreateSorfContrastMultiScaleMasks(sorfScales);

localContrastDiameter = int8(10);
localContrastArea = ImageForces.Masks.MaskAreas.RectangularUniformArea(localContrastDiameter);
localContrastMaskFunction = ImageForces.Masks.MaskFunctions.ExponentMaskFunctionGenerator(double(localContrastDiameter)/2);
localContrastMask = ImageForces.Masks.CreateFunctionMask(localContrastArea,localContrastMaskFunction,true);

image = ones(50);
contrastImage = [];
contrastImage.image = image;
contrastImage.imageContrastBoundryBehaviour = ImageForces.Enums.ImageBoundryBehaviour.symmetric;
contrastImage.imageSorfBoundryBehaviour = ImageForces.Enums.ImageBoundryBehaviour.circular;
localContrastFunction = ImageForces.SORF.ContrastFunctions.ContrastContrastInductionFunctionGenerator(localContrastMask,{});
sorfResponse = ImageForces.SORF.SorfLocalContrastResponse(contrastImage, sorfMasks, localContrastFunction,{});

assert(isequal(size(sorfResponse), size(image)),strcat(mfilename(),' failed'));
imagesc(sorfResponse);
disp(strcat(mfilename(),' passed'));