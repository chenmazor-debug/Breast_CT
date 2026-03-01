function [centerMask, surroundMask] = DarkBackgroundRectangularRingArea(centerDiameter)
    
    if(~isscalar(centerDiameter) || ~isinteger(centerDiameter) || centerDiameter < 1)
        error(strcat(mfilename(),': centerDiameter must be a single positive integer value'));
    end
    
    surroundDiameter = 2 * centerDiameter;
    [centerMask, surroundMask] = ImageForces.Masks.MaskAreas.RectangularRingArea(centerDiameter, surroundDiameter);
end