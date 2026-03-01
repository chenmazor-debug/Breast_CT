diameter = int8(3);
expectedMask = [1 1 1;1 1 1;1 1 1];
mask = ImageForces.Masks.MaskAreas.RectangularUniformArea(diameter);

assert(isequal(mask, expectedMask),strcat(mfilename(),' failed on mask'));

disp(strcat(mfilename(),' passed'));