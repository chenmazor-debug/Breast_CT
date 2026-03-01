function response = BrightnessResponse(brightnessImage, brightnessMask)
    
    if(~isstruct(brightnessImage))
        error(strcat(mfilename(),': sorfImage must be a struct'));
    end
    
    if(~isfield(brightnessImage,'imageBoundryBehaviour'))
        error(strcat(mfilename(),': sorfImage must have a struct field named imageBoundryBehaviour'));
    end
    imageBoundryBehaviour = brightnessImage.imageBoundryBehaviour;
    
    if(~isa(imageBoundryBehaviour, 'ImageForces.Enums.ImageBoundryBehaviour'))
        error(strcat(mfilename(),': imageBoundryBehaviour must be an enum of type ImageForces.Enums.ImageBoundryBehaviour'));
    end
    
    if(~isfield(brightnessImage,'image'))
        error(strcat(mfilename(),': brightnessImage must have a struct field named image'));
    end
    image = brightnessImage.image;
    
    if(ndims(image) ~= 2)
        error(strcat(mfilename(),': number of dimensions for image must be 2'));
    end
    
    if(ndims(brightnessMask) ~= 2)
        error(strcat(mfilename(),': number of dimensions for brightnessMask must be 2'));
    end
    sizeWarningFactor = 0.2;
    imageSize = size(image);
    maskSize= size(brightnessMask);
    sizeFactor = maskSize./imageSize;
    if(sum(sizeFactor > sizeWarningFactor) ~=0)
        warning(strcat(mfilename(),': brightness mask is fairly big comapred to the image to filter, might affect calculations'));
    end
    
    response = imfilter(image, brightnessMask, char(imageBoundryBehaviour), 'same');
%     response = stdfilt(image, true(5));

end