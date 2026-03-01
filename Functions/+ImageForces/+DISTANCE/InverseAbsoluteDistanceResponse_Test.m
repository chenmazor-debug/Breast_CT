brigthnessImage = [1,2,3;4,5,6;7,8,9];
desiredValue = 5;
epsilonRegulation = 0.1;
response = ImageForces.DISTANCE.InverseAbsoluteDistanceResponse(brigthnessImage,desiredValue, epsilonRegulation);
[maxNumber,location] = max(response(:));
expectedLocation = 5;
assert(isequal(expectedLocation, location),strcat(mfilename(),' failed'));


disp(strcat(mfilename(),' passed'));