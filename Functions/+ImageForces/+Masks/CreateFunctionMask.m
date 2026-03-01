function mask = CreateFunctionMask(areaIndicator, func, normalizeMask,ShiftMaskPixels)
    %check inputs
    if(ndims(areaIndicator) ~= 2)
        error(strcat(mfilename(),': number of dimensions for areaIndicator must be 2'));
    end
    
    nonZeroOneIndexes = (areaIndicator ~= 0) .* (areaIndicator ~= 1);
    if(any(nonZeroOneIndexes(:)))
        error(strcat(mfilename(),': areaIndicator must hold only 0 or 1'));
    end
    
    if(~isa(func,'function_handle'))
        error(strcat(mfilename(),': func must be a function handle'));
    end
    
    if(~islogical(normalizeMask) || ~isscalar(normalizeMask))
        error(strcat(mfilename(),': normalizeMask must be true or false'));
    end
    
    areaSize = size(areaIndicator);
    m = areaSize(2); %X axis
    n = areaSize(1); %Y axis
    
    [Xgrid, Ygrid] = meshgrid(-floor(m/2):ceil(m/2)-1,-floor(n/2):ceil(n/2)-1);
    
    %create normalized center mask
%     mask = areaIndicator.*func(circshift(Xgrid,[1,2]),Ygrid);
    mask = areaIndicator.*func(Xgrid,Ygrid);

    if(normalizeMask)
        mask = mask / sum(mask(:));
    end
end