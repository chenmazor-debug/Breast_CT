
function [localContrast, localContrastVectors] = SorfLocalContrastResponse(contrastImage, sorfMasks, localContrastFunction, sorfKUserControlFuncs)
    
    if(~isstruct(contrastImage))
        error(strcat(mfilename(),': contrastImage must be a struct'));
    end
    
    if(~isfield(contrastImage,'imageContrastBoundryBehaviour'))
        error(strcat(mfilename(),': contrastImage must have a struct field named imageContrastBoundryBehaviour'));
    end
    imageContrastBoundryBehaviour = contrastImage.imageContrastBoundryBehaviour;
    
    if(~isa(imageContrastBoundryBehaviour, 'ImageForces.Enums.ImageBoundryBehaviour'))
        error(strcat(mfilename(),': imageContrastBoundryBehaviour must be an enum of type ImageForces.Enums.ImageBoundryBehaviour'));
    end
    
    if(~isfield(contrastImage,'imageSorfBoundryBehaviour'))
        error(strcat(mfilename(),': contrastImage must have a struct field named imageSorfBoundryBehaviour'));
    end
    imageSorfBoundryBehaviour = contrastImage.imageSorfBoundryBehaviour;
    
    if(~isa(imageSorfBoundryBehaviour, 'ImageForces.Enums.ImageBoundryBehaviour'))
        error(strcat(mfilename(),': imageSorfBoundryBehaviour must be an enum of type ImageForces.Enums.ImageBoundryBehaviour'));
    end
    
    if(~isfield(contrastImage,'image'))
        error(strcat(mfilename(),': contrastImage must have a struct field named image'));
    end
    image = contrastImage.image;
    
    if(ndims(image) ~= 2)
        error(strcat(mfilename(),': number of dimensions for image must be 2'));
    end
    
    if(~isvector(sorfMasks) || ~iscell(sorfMasks))
        error(strcat(mfilename(),':  sorfMasks must be a cell array vector'));
    end
    
    for i=1:length(sorfMasks)
        if(ndims(sorfMasks{i}) ~= 2)
            error(strcat(mfilename(),': number of dimensions for all sorfMasks must be 2'));
        end
    end
    
    if(~isa(localContrastFunction,'function_handle'))
                error(strcat(mfilename(),': localContrastFunction must be a function handle'));
    end
        
    numOfSorfKUserControlFuncs = length(sorfKUserControlFuncs);
    if(numOfSorfKUserControlFuncs ~= 0)
        if(~isvector(sorfKUserControlFuncs))
            error(strcat(mfilename(),':  sorfKUserControlFuncs must be a vector cell array or an empty cell array'));
        end
        for i = 1:numOfSorfKUserControlFuncs
            if(~isa(sorfKUserControlFuncs{i},'function_handle'))
                error(strcat(mfilename(),': sorfKUserControlFuncs must hold function handle members only'));
            end
        end
    end
    
    imageSize = size(image);
    numOfMasks = length(sorfMasks);
    sorfImage = [];
    sorfImage.image = image;
    sorfImage.imageBoundryBehaviour = imageSorfBoundryBehaviour;
    sorfResponsesSize = [imageSize numOfMasks];
    sorfResponses = zeros(sorfResponsesSize);
    for k=1:numOfMasks
        sorfResponses(:,:,k) = ImageForces.SORF.SorfResponse(sorfImage, sorfMasks{k});
        for f=1:numOfSorfKUserControlFuncs
            sorfKUserControlFuncs{f}(sorfResponses(:,:,k),k);
        end
    end
    localContrast = localContrastFunction(contrastImage, sorfResponses);
    localContrastVectors = sorfResponses;
end