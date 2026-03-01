
function [localRelativeBrightness, localRelativeBrightnessVectors] = LocalRelativeBrightnessResponse(relativeBrightnessImage, relativeBrightnessMasks, localRelativeBrightnessFunction, relativeBrightnessKUserControlFuncs)
    
    if(~isstruct(relativeBrightnessImage))
        error(strcat(mfilename(),': relativeBrightnessImage must be a struct'));
    end
    
    if(~isfield(relativeBrightnessImage,'imageLocalRelativeBrightnessBoundryBehaviour'))
        error(strcat(mfilename(),': relativeBrightnessImage must have a struct field named imageLocalRelativeBrightnessBoundryBehaviour'));
    end
    imageLocalRelativeBrightnessBoundryBehaviour = relativeBrightnessImage.imageLocalRelativeBrightnessBoundryBehaviour;
    
    if(~isa(imageLocalRelativeBrightnessBoundryBehaviour, 'ImageForces.Enums.ImageBoundryBehaviour'))
        error(strcat(mfilename(),': imageLocalRelativeBrightnessBoundryBehaviour must be an enum of type ImageForces.Enums.ImageBoundryBehaviour'));
    end
    
    if(~isfield(relativeBrightnessImage,'imageScaleRelativeBrightnessBoundryBehaviour'))
        error(strcat(mfilename(),': relativeBrightnessImage must have a struct field named imageScaleRelativeBrightnessBoundryBehaviour'));
    end
    imageScaleRelativeBrightnessBoundryBehaviour = relativeBrightnessImage.imageScaleRelativeBrightnessBoundryBehaviour;
    
    if(~isa(imageScaleRelativeBrightnessBoundryBehaviour, 'ImageForces.Enums.ImageBoundryBehaviour'))
        error(strcat(mfilename(),': imageScaleRelativeBrightnessBoundryBehaviour must be an enum of type ImageForces.Enums.ImageBoundryBehaviour'));
    end
    
    if(~isfield(relativeBrightnessImage,'image'))
        error(strcat(mfilename(),': relativeBrightnessImage must have a struct field named image'));
    end
    image = relativeBrightnessImage.image;
    
    if(ndims(image) ~= 2)
        error(strcat(mfilename(),': number of dimensions for image must be 2'));
    end
    
    if(~isvector(relativeBrightnessMasks) || ~iscell(relativeBrightnessMasks))
        error(strcat(mfilename(),':  relativeBrightnessMasks must be a cell array vector'));
    end
    
    for i=1:length(relativeBrightnessMasks)
        if(ndims(relativeBrightnessMasks{i}) ~= 2)
            error(strcat(mfilename(),': number of dimensions for all relativeBrightnessMasks must be 2'));
        end
    end
    
    if(~isa(localRelativeBrightnessFunction,'function_handle'))
                error(strcat(mfilename(),': localRelativeBrightnessFunction must be a function handle'));
    end
        
    numOfRelativeBrightnessKUserControlFuncs = length(relativeBrightnessKUserControlFuncs);
    if(numOfRelativeBrightnessKUserControlFuncs ~= 0)
        if(~isvector(relativeBrightnessKUserControlFuncs))
            error(strcat(mfilename(),':  relativeBrightnessKUserControlFuncs must be a vector cell array or an empty cell array'));
        end
        for i = 1:numOfRelativeBrightnessKUserControlFuncs
            if(~isa(relativeBrightnessKUserControlFuncs{i},'function_handle'))
                error(strcat(mfilename(),': relativeBrightnessKUserControlFuncs must hold function handle members only'));
            end
        end
    end
    
    imageSize = size(image);
    numOfMasks = length(relativeBrightnessMasks);
    relativeBrightnessImage = [];
    relativeBrightnessImage.image = image;
    relativeBrightnessImage.imageBoundryBehaviour = imageScaleRelativeBrightnessBoundryBehaviour;
    relativeBrightnessResponsesSize = [imageSize numOfMasks];
    relativeBrightnessResponses = zeros(relativeBrightnessResponsesSize);
    for k=1:numOfMasks
        relativeBrightnessResponses(:,:,k) = ImageForces.RELATIVEBRIGHTNESS.RelativeBrightnessResponse(relativeBrightnessImage, relativeBrightnessMasks{k});
        for f=1:numOfRelativeBrightnessKUserControlFuncs
            relativeBrightnessKUserControlFuncs{f}(relativeBrightnessResponses(:,:,k),k);
        end
    end
    localRelativeBrightness = localRelativeBrightnessFunction(relativeBrightnessImage, relativeBrightnessResponses);
    localRelativeBrightnessVectors = relativeBrightnessResponses;
end