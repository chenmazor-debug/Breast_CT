function multiScaleMasks = CreateRelativeBrightnessMultiScaleMasks(scales)
    %check inputs
    scalesSize = size(scales);
    if(scalesSize(2) ~= 2)
        error(strcat(mfilename(),':  scales must be a (m by 2) matrix of integers'));
    end
    scalesNotIntegers = ~isinteger(scales);
    if(any(scalesNotIntegers(:)))
        error(strcat(mfilename(),':  scales must be a (m by 2) matrix of integers'));
    end
    
    numberOfMasks = scalesSize(1);
    multiScaleMasks = cell(1,numberOfMasks);
    for i=1:numberOfMasks
        centerDiameter = scales(i,1);
        surroundDiameter = scales(i,2);
        [centerArea, surroundArea] = ImageForces.Masks.MaskAreas.RectangularRingArea(centerDiameter,surroundDiameter);
        
        centerArea = circshift(centerArea,[1,centerDiameter]);
        surroundArea = circshift(surroundArea,[1,centerDiameter]);
        
        ShiftMaskPixels = centerDiameter;
        centerGaussianFunction = ImageForces.Masks.MaskFunctions.GaussianMaskFunctionGenerator(double(centerDiameter),ShiftMaskPixels);
        surroundGaussianFunction = ImageForces.Masks.MaskFunctions.GaussianMaskFunctionGenerator(double(surroundDiameter),ShiftMaskPixels);
        multiScaleMasks{i} = ImageForces.RELATIVEBRIGHTNESS.CreateRelativeBrightnessMask(centerArea, centerGaussianFunction,surroundArea,surroundGaussianFunction,ShiftMaskPixels);
    end
end