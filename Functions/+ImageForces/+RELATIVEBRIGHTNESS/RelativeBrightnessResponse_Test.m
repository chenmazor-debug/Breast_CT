relativeBrightnessMask = [-1/8 -1/8 -1/8;-1/8 1 -1/8;-1/8 -1/8 -1/8];
image = ones(50);
relativeBrightnessImage = [];
relativeBrightnessImage.image = image;
relativeBrightnessImage.imageBoundryBehaviour = ImageForces.Enums.ImageBoundryBehaviour.circular;
expectedRelativeBrightnessResponse = ones(50);
relativeBrightnessResponse = ImageForces.RELATIVEBRIGHTNESS.RelativeBrightnessResponse(relativeBrightnessImage, relativeBrightnessMask);
assert(isequal(round(relativeBrightnessResponse,4), round(expectedRelativeBrightnessResponse,4)),strcat(mfilename(),' failed'));

relativeBrightnessMask = [-1/7 -1/8 -1/8;-1/8 1 -1/8;-1/8 -1/8 -1/8];
image = ones(50);
relativeBrightnessImage = [];
relativeBrightnessImage.image = image;
relativeBrightnessImage.imageBoundryBehaviour = ImageForces.Enums.ImageBoundryBehaviour.circular;
expectedRelativeBrightnessResponse = ones(50);
relativeBrightnessResponse = ImageForces.RELATIVEBRIGHTNESS.RelativeBrightnessResponse(relativeBrightnessImage, relativeBrightnessMask);
assert(~isequal(round(relativeBrightnessResponse,4), round(expectedRelativeBrightnessResponse,4)),strcat(mfilename(),' failed'));

disp(strcat(mfilename(),' passed'));