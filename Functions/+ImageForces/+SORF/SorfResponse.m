function response = SorfResponse(sorfImage, sorfMask)
    
    if(~isstruct(sorfImage))
        error(strcat(mfilename(),': sorfImage must be a struct'));
    end
    
    if(~isfield(sorfImage,'imageBoundryBehaviour'))
        error(strcat(mfilename(),': sorfImage must have a struct field named imageBoundryBehaviour'));
    end
    imageBoundryBehaviour = sorfImage.imageBoundryBehaviour;
    
    if(~isa(imageBoundryBehaviour, 'ImageForces.Enums.ImageBoundryBehaviour'))
        error(strcat(mfilename(),': imageBoundryBehaviour must be an enum of type ImageForces.Enums.ImageBoundryBehaviour'));
    end
    
    if(~isfield(sorfImage,'image'))
        error(strcat(mfilename(),': sorfImage must have a struct field named image'));
    end
    image = sorfImage.image;
    
    if(ndims(image) ~= 2)
        error(strcat(mfilename(),': number of dimensions for image must be 2'));
    end
    
    if(ndims(sorfMask) ~= 2)
        error(strcat(mfilename(),': number of dimensions for sorfMask must be 2'));
    end
    sizeWarningFactor = 0.2;
    imageSize = size(image);
    maskSize= size(sorfMask);
    sizeFactor = maskSize./imageSize;
    if(sum(sizeFactor > sizeWarningFactor) ~=0)
        warning(strcat(mfilename(),': sorf mask is fairly big comapred to the image to filter, might affect calculations'));
    end
    
    response = imfilter(image, sorfMask, char(imageBoundryBehaviour), 'same');
    
end