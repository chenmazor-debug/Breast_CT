function response = PowerDistanceResponse(image, desiredValue, powerNumber)
    
    if(~ismatrix(image))
        error(strcat(mfilename(),': image must be a matrix'));
    end
    
    if(~isscalar(desiredValue)||~isnumeric(desiredValue))
        error(strcat(mfilename(),': desiredValue must be a numeric scalar'));
    end
    
    if(~isscalar(powerNumber)||~isnumeric(powerNumber))
        error(strcat(mfilename(),': epsilonRegulation must be a numeric scalar'));
    end
    
    response = (image-desiredValue).^powerNumber;
end