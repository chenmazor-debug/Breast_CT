function mask = CreateBrightnessMask(area, func)
    %check inputs
    if(ndims(area) ~= 2)
        error(strcat(mfilename(),': number of dimensions for area must be 2'));
    end
    
    
    areaSize = size(area);
        
    validityMap = ones(areaSize);
    areaZeroIndicator = area == 0;
    areaOneIndicator = area == 1;
    areaValidityMap = areaZeroIndicator + areaOneIndicator;
    
    if(~isequal(validityMap, areaValidityMap))
        error(strcat(mfilename(),': area must have only ones and zeros'));
    end
    
    if(~isa(func,'function_handle'))
        error(strcat(mfilename(),': func must be a function handle'));
    end
    
        
    %create normalized mask
    mask = ImageForces.Masks.CreateFunctionMask(area,func,true,0);
end