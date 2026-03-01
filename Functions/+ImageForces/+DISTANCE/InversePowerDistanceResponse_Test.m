brigthnessImage = [1,2,3;4,5,6;7,8,9];
desiredValue = 5;
epsilonRegulation = 0.1;
powerNumber = 2;
response = ImageForces.DISTANCE.InversePowerDistanceResponse(brigthnessImage,desiredValue, powerNumber, epsilonRegulation);
[maxNumber,location] = max(response(:));
expectedLocation = 5;
assert(isequal(expectedLocation, location),strcat(mfilename(),' failed'));


disp(strcat(mfilename(),' passed'));