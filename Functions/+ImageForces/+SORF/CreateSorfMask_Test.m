centerDiameter = 1;
surroundDiameter = 3;
centerDiameterInteger = int8(centerDiameter);
surroundDiameterInteger = int8(surroundDiameter);

[centerArea,surroundArea] = ImageForces.Masks.MaskAreas.RectangularRingArea(centerDiameterInteger,surroundDiameterInteger);
centerGaussian = ImageForces.Masks.MaskFunctions.GaussianMaskFunctionGenerator(centerDiameter/2);
surroundGaussian = ImageForces.Masks.MaskFunctions.GaussianMaskFunctionGenerator(surroundDiameter/2);

expectedMask = [-0.0977 -0.1523 -0.0977;-0.1523 1 -0.1523;-0.0977 -0.1523 -0.0977];
sorfMask = ImageForces.SORF.CreateSorfMask(centerArea, centerGaussian, surroundArea, surroundGaussian);
sorfMask4Digits = round(sorfMask,4);
assert(isequal(sorfMask4Digits, expectedMask),strcat(mfilename(),' failed'));

disp(strcat(mfilename(),' passed'));
