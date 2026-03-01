function centerMask = RectangularUniformArea(diameter)
    %check inputs
    if(~isinteger(diameter) || ~isscalar(diameter) || diameter < 1)
        error(strcat(mfilename(),': centerDiameter must be a single positive integer value'));
    end
    
    centerMask = ones(diameter);
end