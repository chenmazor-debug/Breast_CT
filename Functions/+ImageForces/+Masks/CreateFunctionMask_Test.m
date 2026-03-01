diameter = 3;
diameterInteger = int8(diameter);

area = ImageForces.Masks.MaskAreas.RectangularUniformArea(diameterInteger);

exponent = ImageForces.Masks.MaskFunctions.ExponentMaskFunctionGenerator(diameter/2);

expectedMask = [0.4111, 0.6412, 0.4111; 0.6412, 1.0000, 0.6412; 0.4111, 0.6412, 0.4111];
mask = ImageForces.Masks.CreateFunctionMask(area, exponent, false);
mask4Digits = round(mask,4);
assert(isequal(mask4Digits, expectedMask),strcat(mfilename(),' failed'));

expectedMask = [0.0789, 0.1231, 0.0789; 0.1231, 0.1920, 0.1231; 0.0789, 0.1231, 0.0789];
mask = ImageForces.Masks.CreateFunctionMask(area, exponent, true);
mask4Digits = round(mask,4);
assert(isequal(mask4Digits, expectedMask),strcat(mfilename(),' failed'));

disp(strcat(mfilename(),' passed'));
