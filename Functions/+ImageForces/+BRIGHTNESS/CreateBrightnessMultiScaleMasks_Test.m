masksDiamaeters = int8([1;2;3;4;5]);
brightnessMasks = ImageForces.BRIGHTNESS.CreateBrightnessMultiScaleMasks(masksDiamaeters);

assert(isequal(size(brightnessMasks), [1,5]),strcat(mfilename(),' failed'));
assert(all(iscell(brightnessMasks)) ,strcat(mfilename(),' failed'));
for i=1:5
   sizeOfMask = size(brightnessMasks{i});
   expectedSizeOfmask = [masksDiamaeters(i),masksDiamaeters(i)];
   assert(isequal(sizeOfMask, expectedSizeOfmask) ,strcat(mfilename(),' failed'));
end
disp(strcat(mfilename(),' passed'));
