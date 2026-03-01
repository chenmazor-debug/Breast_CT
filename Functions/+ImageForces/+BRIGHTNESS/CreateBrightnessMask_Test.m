diameter = 3;
diameterInteger = int8(diameter);

area = ImageForces.Masks.MaskAreas.RectangularUniformArea(diameterInteger);
gaussian = ImageForces.Masks.MaskFunctions.GaussianMaskFunctionGenerator(diameter/2);

expectedMask = [0.0789 0.1231 0.0789;0.1231 0.1920 0.1231;0.0789 0.1231 0.0789];
brightnessMask = ImageForces.BRIGHTNESS.CreateBrightnessMask(area, gaussian);
brightnessMask4Digits = round(brightnessMask,4);
assert(isequal(brightnessMask4Digits, expectedMask),strcat(mfilename(),' failed'));

disp(strcat(mfilename(),' passed'));
