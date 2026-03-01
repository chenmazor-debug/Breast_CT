centerDiameter = int8(3);
expectedCenterMask = [0 0 0 0 0 0;0 1 1 1 0 0;0 1 1 1 0 0;0 1 1 1 0 0;0 0 0 0 0 0;0 0 0 0 0 0];
expectedSurroundMask = 1 - expectedCenterMask;
[centerMask, surroundMask] = ImageForces.Masks.MaskAreas.DarkBackgroundRectangularRingArea(centerDiameter);
centerGain = sum(centerMask(:));
surroundGain = sum(surroundMask(:));

assert(isequal(centerMask, expectedCenterMask),strcat(mfilename(),' failed on centerMask'));
assert(isequal(surroundMask, expectedSurroundMask),strcat(mfilename(),' failed on surroundMask'));
assert(isequal(surroundGain/centerGain,3),strcat(mfilename(),' failed on gain ratio'));

disp(strcat(mfilename(),' passed'));