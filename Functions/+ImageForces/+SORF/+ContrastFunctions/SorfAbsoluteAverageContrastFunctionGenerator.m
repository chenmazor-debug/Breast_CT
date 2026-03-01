function contrastFunction = SorfAverageContrastFunctionGenerator(contrastKUserControlFuncs )
%CONTRASTCONTRASTINDUCTIONFUNCTIONGENERATOR Summary of this function goes here
%   Detailed explanation goes here
    
    numOfContrastKUserControlFuncs = length(contrastKUserControlFuncs);
    if(numOfContrastKUserControlFuncs ~= 0)
        if(~isvector(contrastKUserControlFuncs))
            error(strcat(mfilename(),':  contrastKUserControlFuncs must be a vector cell array or an empty cell array'));
        end
        for i = 1:numOfContrastKUserControlFuncs
            if(~isa(contrastKUserControlFuncs{i},'function_handle'))
                error(strcat(mfilename(),': contrastKUserControlFuncs must hold function handle members only'));
            end
        end
    end

    function contrast = ContrastFunction(contrastImage, sorfResponses)
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
        
        sorfResponsesSize = size(sorfResponses);
        contrast = zeros(sorfResponsesSize(1),sorfResponsesSize(2));
        numOfResponses = sorfResponsesSize(3);
        for k=1:numOfResponses
            sorfResponseK = sorfResponses(:,:,k);
            localContrastK = abs(sorfResponseK) / numOfResponses;
            for f=1:numOfContrastKUserControlFuncs
                contrastKUserControlFuncs{f}(localContrastK,k);
            end

            contrast = contrast + localContrastK;
        end
    end

    contrastFunction = @ContrastFunction;
end

