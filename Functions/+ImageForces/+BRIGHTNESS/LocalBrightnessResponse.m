function localBrightness = LocalBrightnessResponse(brightnessImage, brightnessMasks, localBrightnessFunction, brightnessKUserControlFuncs)
    
    if(~isstruct(brightnessImage))
        error(strcat(mfilename(),': brightnessImage must be a struct'));
    end
    
    if(~isfield(brightnessImage,'imageLocalBrightnessBoundryBehaviour'))
        error(strcat(mfilename(),': brightnessImage must have a struct field named imageLocalBrightnessBoundryBehaviour'));
    end
    imageLocalBrightnessBoundryBehaviour = brightnessImage.imageLocalBrightnessBoundryBehaviour;
    
    if(~isa(imageLocalBrightnessBoundryBehaviour, 'ImageForces.Enums.ImageBoundryBehaviour'))
        error(strcat(mfilename(),': imageLocalBrightnessBoundryBehaviour must be an enum of type ImageForces.Enums.ImageBoundryBehaviour'));
    end
    
    if(~isfield(brightnessImage,'imageScaleBrightnessBoundryBehaviour'))
        error(strcat(mfilename(),': brightnesstImage must have a struct field named imageScaleBrightnessBoundryBehaviour'));
    end
    imageScaleBrightnessBoundryBehaviour = brightnessImage.imageScaleBrightnessBoundryBehaviour;
    
    if(~isa(imageScaleBrightnessBoundryBehaviour, 'ImageForces.Enums.ImageBoundryBehaviour'))
        error(strcat(mfilename(),': imageScaleBrightnessBoundryBehaviour must be an enum of type ImageForces.Enums.ImageBoundryBehaviour'));
    end
    
    if(~isfield(brightnessImage,'image'))
        error(strcat(mfilename(),': brightnessImage must have a struct field named image'));
    end
    image = brightnessImage.image;
    
    if(ndims(image) ~= 2)
        error(strcat(mfilename(),': number of dimensions for image must be 2'));
    end
    
    if(~isvector(brightnessMasks) || ~iscell(brightnessMasks))
        error(strcat(mfilename(),':  brightnessMasks must be a cell array vector'));
    end
    
    for i=1:length(brightnessMasks)
        if(ndims(brightnessMasks{i}) ~= 2)
            error(strcat(mfilename(),': number of dimensions for all brightnessMasks must be 2'));
        end
    end
    
    if(~isa(localBrightnessFunction,'function_handle'))
                error(strcat(mfilename(),': localBrightnessFunction must be a function handle'));
    end
        
    numOfBrightnessKUserControlFuncs = length(brightnessKUserControlFuncs);
    if(numOfBrightnessKUserControlFuncs ~= 0)
        if(~isvector(brightnessKUserControlFuncs))
            error(strcat(mfilename(),':  brightnessKUserControlFuncs must be a vector cell array or an empty cell array'));
        end
        for i = 1:numOfBrightnessKUserControlFuncs
            if(~isa(brightnessKUserControlFuncs{i},'function_handle'))
                error(strcat(mfilename(),': brightnessKUserControlFuncs must hold function handle members only'));
            end
        end
    end
    
    imageSize = size(image);
    numOfMasks = length(brightnessMasks);
    brightnessScaleImage = [];
    brightnessScaleImage.image = image;
    brightnessScaleImage.imageBoundryBehaviour = imageScaleBrightnessBoundryBehaviour;
    brightnessResponsesSize = [imageSize numOfMasks];
    brightnessResponses = zeros(brightnessResponsesSize);
    for k=1:numOfMasks
        brightnessResponses(:,:,k) = ImageForces.BRIGHTNESS.BrightnessResponse(brightnessScaleImage, brightnessMasks{k});
        for f=1:numOfBrightnessKUserControlFuncs
            brightnessKUserControlFuncs{f}(brightnessResponses(:,:,k),k);
        end
    end
    localBrightness = localBrightnessFunction(brightnessImage, brightnessResponses);
end