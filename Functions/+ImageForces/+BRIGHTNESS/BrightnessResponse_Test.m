brightnessMask = [1/9 1/9 1/9;1/9 1/9 1/9;1/9 1/9 1/9];
image = ones(50);
brightnessImage = [];
brightnessImage.image = image;
brightnessImage.imageBoundryBehaviour = ImageForces.Enums.ImageBoundryBehaviour.circular;
expectedBrightnessResponse = round(ones(50),4);
brightnessResponse = ImageForces.BRIGHTNESS.BrightnessResponse(brightnessImage, brightnessMask);
brightnessResponseRounded = round(brightnessResponse,4);
assert(isequal(brightnessResponseRounded, expectedBrightnessResponse),strcat(mfilename(),' failed'));

brightnessMask = [1/8 1/9 1/9;1/9 1/9 1/9;1/9 1/9 1/9];
image = ones(50);
brightnessImage = [];
brightnessImage.image = image;
brightnessImage.imageBoundryBehaviour = ImageForces.Enums.ImageBoundryBehaviour.circular;
expectedBrightnessResponse = round(ones(50),4);
brightnessResponse = ImageForces.SORF.SorfResponse(brightnessImage, brightnessMask);
brightnessResponseRounded = round(brightnessResponse,4);

assert(~isequal(brightnessResponseRounded, expectedBrightnessResponse),strcat(mfilename(),' failed'));

disp(strcat(mfilename(),' passed'));