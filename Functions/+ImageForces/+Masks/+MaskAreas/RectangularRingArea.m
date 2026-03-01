function [centerMask, surroundMask] = RectangularRingArea(centerDiameter, surroundDiameter)
    %check inputs
    if(~isinteger(centerDiameter) || ~isscalar(centerDiameter) || centerDiameter < 1)
        error(strcat(mfilename(),': centerDiameter must be a single positive integer value'));
    end
    
    if(~isinteger(surroundDiameter) || ~isscalar(surroundDiameter) || surroundDiameter < 1)
        error(strcat(mfilename(),': surroundDiameter must be a single positive integer value'));
    end
    
    if(surroundDiameter <= centerDiameter)
        error(strcat(mfilename(),': surroundDiameter bigger than centerDiameter'));               
    end
    
    diameterDiff = double(surroundDiameter - centerDiameter);
    floorHalfDiff = floor(diameterDiff / 2);
    ceilHalfDiff = ceil(diameterDiff / 2);
    centerMask = zeros(surroundDiameter);
    centerMask(1+floorHalfDiff:end-ceilHalfDiff,1+floorHalfDiff:end-ceilHalfDiff) = 1;
    surroundMask = ones(surroundDiameter) - centerMask;
end