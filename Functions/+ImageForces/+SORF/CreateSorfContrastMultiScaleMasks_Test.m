masksDiamaeters = int8([1,3;2,4;2,5;4,7;3,7]);
sorfMasks = ImageForces.SORF.CreateSorfContrastMultiScaleMasks(masksDiamaeters);

assert(isequal(size(sorfMasks), [1,5]),strcat(mfilename(),' failed'));
assert(all(iscell(sorfMasks)) ,strcat(mfilename(),' failed'));
for i=1:4
   sizeOfMask = size(sorfMasks{i});
   expectedSizeOfmask = [masksDiamaeters(i,2),masksDiamaeters(i,2)];
   assert(isequal(sizeOfMask, expectedSizeOfmask) ,strcat(mfilename(),' failed'));
end
disp(strcat(mfilename(),' passed'));
