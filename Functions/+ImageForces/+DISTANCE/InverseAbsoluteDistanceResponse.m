function response = InverseAbsoluteDistanceResponse(image, desiredValue,epsilonRegulation)
    
    if(~ismatrix(image))
        error(strcat(mfilename(),': image must be a matrix'));
    end
    
    if(~isscalar(desiredValue)||~isnumeric(desiredValue))
        error(strcat(mfilename(),': desiredValue must be a numeric scalar'));
    end
    
    if(~isscalar(epsilonRegulation)||~isnumeric(epsilonRegulation) || epsilonRegulation <= 0)
        error(strcat(mfilename(),': epsilonRegulation must be a positive numeric scalar'));
    end
    
    distance = abs(image-desiredValue);
    response = 1 ./ (distance + epsilonRegulation);
end