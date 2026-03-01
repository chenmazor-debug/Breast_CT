function multiScaleMasks = CreateBrightnessMultiScaleMasks(scales)
    %check inputs
    if(~isvector(scales))
        error(strcat(mfilename(),':  scales must be a vector of integers'));
    end
    scalesNotIntegers = ~isinteger(scales);
    if(any(scalesNotIntegers(:)))
        error(strcat(mfilename(),':  scales must be a vector of integers'));
    end
    
    numberOfMasks = length(scales);
    multiScaleMasks = cell(1,numberOfMasks);
    for i=1:numberOfMasks
        diameter = scales(i);
        area = ImageForces.Masks.MaskAreas.RectangularUniformArea(diameter);
        gaussianFunction = ImageForces.Masks.MaskFunctions.GaussianMaskFunctionGenerator(double(diameter),0);
        multiScaleMasks{i} = ImageForces.BRIGHTNESS.CreateBrightnessMask(area, gaussianFunction);
    end
end