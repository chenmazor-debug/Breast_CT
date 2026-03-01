function mask = CreateRelativeBrightnessMask(centerArea, centerFunc, surroundArea, surroundFunc,ShiftMaskPixels)
    %check inputs
    if(ndims(centerArea) ~= 2)
        error(strcat(mfilename(),': number of dimensions for centerArea must be 2'));
    end
    
    if(ndims(surroundArea) ~= 2)
        error(strcat(mfilename(),': number of dimensions for surroundArea must be 2'));
    end
    
    centerAreaSize = size(centerArea);
    surroundAreaSize = size(surroundArea);
    if(~isequal(centerAreaSize, surroundAreaSize))
        error(strcat(mfilename(),': centerArea and surroundArea must be the same size'));
    end
    
    validityMap = ones(centerAreaSize);
    centerAreaZeroIndicator = centerArea == 0;
    centerAreaOneIndicator = centerArea == 1;
    surroundAreaZeroIndicator = surroundArea == 0;
    surroundAreaOneIndicator = surroundArea == 1;
    centerAreaValidityMap = centerAreaZeroIndicator + centerAreaOneIndicator;
    surroundAreaValidityMap = surroundAreaZeroIndicator + surroundAreaOneIndicator;
    if(~isequal(validityMap, centerAreaValidityMap))
        error(strcat(mfilename(),': centerArea must have only ones and zeros'));
    end
    
    if(~isequal(validityMap, surroundAreaValidityMap))
        error(strcat(mfilename(),': surroundArea must have only ones and zeros'));
    end
    
    fullAreaOneIndicator = centerAreaOneIndicator + surroundAreaOneIndicator;
    if(~isequal(validityMap, fullAreaOneIndicator))
        warning(strcat(mfilename(),': centerArea and surroundArea overlap'));
    end
    
    if(~isa(centerFunc,'function_handle'))
        error(strcat(mfilename(),': centerFunc must be a function handle'));
    end
    
    if(~isa(surroundFunc,'function_handle'))
        error(strcat(mfilename(),': surroundFunc must be a function handle'));
    end
    
    %create normalized center mask
    centerAreaFunctionMask = ImageForces.Masks.CreateFunctionMask(centerArea,centerFunc,true,ShiftMaskPixels);
    %create normalized surround mask
    surroundAreaFunctionMask = ImageForces.Masks.CreateFunctionMask(surroundArea, surroundFunc,true,ShiftMaskPixels);
    %combine masks
    mask = centerAreaFunctionMask - surroundAreaFunctionMask;
end