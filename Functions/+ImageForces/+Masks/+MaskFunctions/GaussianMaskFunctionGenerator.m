function gaussianFunction = GaussianMaskFunctionGenerator(ro,Xshift)
    %check inputs
    if(~isfloat(ro) || ~isscalar(ro) || ro <= 0)
        error(strcat(mfilename(),': ro must be a single positive floating point number'));
    end
    
    function Z = GaussianFunction(X,Y)
        power = -((X-double(Xshift)).^2+Y.^2)/(ro^2);
        Z = exp(power)/(pi*ro);
    end

    gaussianFunction = @GaussianFunction;
end