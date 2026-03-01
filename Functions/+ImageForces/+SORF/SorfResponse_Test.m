sorfMask = [-1/8 -1/8 -1/8;-1/8 1 -1/8;-1/8 -1/8 -1/8];
image = ones(50);
sorfImage = [];
sorfImage.image = image;
sorfImage.imageBoundryBehaviour = ImageForces.Enums.ImageBoundryBehaviour.circular;
expectedSorfResponse = zeros(50);
sorfResponse = ImageForces.SORF.SorfResponse(sorfImage, sorfMask);
assert(isequal(sorfResponse, expectedSorfResponse),strcat(mfilename(),' failed'));

sorfMask = [-1/7 -1/8 -1/8;-1/8 1 -1/8;-1/8 -1/8 -1/8];
image = ones(50);
sorfImage = [];
sorfImage.image = image;
sorfImage.imageBoundryBehaviour = ImageForces.Enums.ImageBoundryBehaviour.circular;
expectedSorfResponse = zeros(50);
sorfResponse = ImageForces.SORF.SorfResponse(sorfImage, sorfMask);
assert(~isequal(sorfResponse, expectedSorfResponse),strcat(mfilename(),' failed'));

disp(strcat(mfilename(),' passed'));