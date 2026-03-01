function response = InversePowerDistanceResponse(image, desiredValue,powerNumber, epsilonRegulation)
    
    if(~ismatrix(image))
        error(strcat(mfilename(),': image must be a matrix'));
    end
    
    if(~isscalar(desiredValue)||~isnumeric(desiredValue))
        error(strcat(mfilename(),': desiredValue must be a numeric scalar'));
    end
    
    if(~isscalar(powerNumber)||~isnumeric(powerNumber) || powerNumber <= 0)
        error(strcat(mfilename(),': powerNumber must be a positive numeric scalar'));
    end
    
    if(~isscalar(epsilonRegulation)||~isnumeric(epsilonRegulation) || epsilonRegulation <= 0)
        error(strcat(mfilename(),': epsilonRegulation must be a positive numeric scalar'));
    end
    
    distance = (image-desiredValue).^powerNumber;
    response = 1 ./ (distance + epsilonRegulation);
end