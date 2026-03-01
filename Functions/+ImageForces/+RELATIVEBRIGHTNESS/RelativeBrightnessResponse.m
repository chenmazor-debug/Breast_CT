function response = RelativeBrightnessResponse(relativeBrightnessImage, relativeBrightnessMask)
    
    if(~isstruct(relativeBrightnessImage))
        error(strcat(mfilename(),': relativeBrightnessImage must be a struct'));
    end
    
    if(~isfield(relativeBrightnessImage,'imageBoundryBehaviour'))
        error(strcat(mfilename(),': relativeBrightnessImage must have a struct field named imageBoundryBehaviour'));
    end
    imageBoundryBehaviour = relativeBrightnessImage.imageBoundryBehaviour;
    
    if(~isa(imageBoundryBehaviour, 'ImageForces.Enums.ImageBoundryBehaviour'))
        error(strcat(mfilename(),': imageBoundryBehaviour must be an enum of type ImageForces.Enums.ImageBoundryBehaviour'));
    end
    
    if(~isfield(relativeBrightnessImage,'image'))
        error(strcat(mfilename(),': relativeBrightnessImage must have a struct field named image'));
    end
    image = relativeBrightnessImage.image;
    
    if(ndims(image) ~= 2)
        error(strcat(mfilename(),': number of dimensions for image must be 2'));
    end
    
    if(ndims(relativeBrightnessMask) ~= 2)
        error(strcat(mfilename(),': number of dimensions for sorfMask must be 2'));
    end
    sizeWarningFactor = 0.2;
    imageSize = size(image);
    maskSize= size(relativeBrightnessMask);
    sizeFactor = maskSize./imageSize;
    if(sum(sizeFactor > sizeWarningFactor) ~=0)
        warning(strcat(mfilename(),': relativeBrightness mask is fairly big comapred to the image to filter, might affect calculations'));
    end
    
    %positiveParts are in the numerator
    %positiveParts are in the denominator
    positiveParts = relativeBrightnessMask > 0;
    negativeParts = relativeBrightnessMask < 0;
    numeratorMask = positiveParts.*relativeBrightnessMask;
    denominatorMask = -(negativeParts.*relativeBrightnessMask);
    image = image+1; %move the axis around 1 to avoid division by 0
    numeratorResponse = imfilter(image, numeratorMask, char(imageBoundryBehaviour), 'same');
    denominatorResponse = imfilter(image, denominatorMask, char(imageBoundryBehaviour), 'same');
    response = numeratorResponse./denominatorResponse;
end