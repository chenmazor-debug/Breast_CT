function localBrightnessFunction = SignedPowerAverageFunctionGenerator(powerNumber ,brightnessKUserControlFuncs )
%CONTRASTCONTRASTINDUCTIONFUNCTIONGENERATOR Summary of this function goes here
%   Detailed explanation goes here
    
    if(~isscalar(powerNumber))
        error(strcat(mfilename(),':  powerNumber must be a scalar'));
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

    function brightness = BrightnessFunction(~, brightnessResponses)
        brighthnessResponsesSize = size(brightnessResponses);
        brightness = zeros(brighthnessResponsesSize(1),brighthnessResponsesSize(2));
        numOfResponses = 1;
        if(length(brighthnessResponsesSize) == 3)
            numOfResponses = brighthnessResponsesSize(3);
        end
        for k=1:numOfResponses
            brightnessResponseK = brightnessResponses(:,:,k);
            localBrightnessK = sign(brightnessResponseK).*(brightnessResponseK.^powerNumber) / numOfResponses;
            for f=1:numOfBrightnessKUserControlFuncs
                brightnessKUserControlFuncs{f}(localBrightnessK,k);
            end

            brightness = brightness + localBrightnessK;
        end
    end

    localBrightnessFunction = @BrightnessFunction;
end

