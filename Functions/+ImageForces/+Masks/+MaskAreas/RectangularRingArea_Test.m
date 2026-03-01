surroundDiameter = int8(5);
centerDiameter = int8(3);
expectedCenterMask = [0 0 0 0 0;0 1 1 1 0;0 1 1 1 0;0 1 1 1 0;0 0 0 0 0];
expectedSurroundMask = 1 - expectedCenterMask;
[centerMask, surroundMask] = ImageForces.Masks.MaskAreas.RectangularRingArea(centerDiameter,surroundDiameter);

assert(isequal(centerMask, expectedCenterMask),strcat(mfilename(),' failed on centerMask'));
assert(isequal(surroundMask, expectedSurroundMask),strcat(mfilename(),' failed on surroundMask'));

surroundDiameter = int8(4);
centerDiameter = int8(2);
expectedCenterMask = [0 0 0 0;0 1 1 0;0 1 1 0;0 0 0 0];
expectedSurroundMask = 1 - expectedCenterMask;
[centerMask, surroundMask] = ImageForces.Masks.MaskAreas.RectangularRingArea(centerDiameter,surroundDiameter);

assert(isequal(centerMask, expectedCenterMask),strcat(mfilename(),' failed on centerMask'));
assert(isequal(surroundMask, expectedSurroundMask),strcat(mfilename(),' failed on surroundMask'));

surroundDiameter = int8(5);
centerDiameter = int8(2);
expectedCenterMask = [0 0 0 0 0;0 1 1 0 0;0 1 1 0 0;0 0 0 0 0;0 0 0 0 0];
expectedSurroundMask = 1 - expectedCenterMask;
[centerMask, surroundMask] = ImageForces.Masks.MaskAreas.RectangularRingArea(centerDiameter,surroundDiameter);

assert(isequal(centerMask, expectedCenterMask),strcat(mfilename(),' failed on centerMask'));
assert(isequal(surroundMask, expectedSurroundMask),strcat(mfilename(),' failed on surroundMask'));

disp(strcat(mfilename(),' passed'));