ro = 10;
gaussFunction = ImageForces.Masks.MaskFunctions.GaussianMaskFunctionGenerator(ro);
[X, Y] = meshgrid(-ro:ro,-ro:ro);
Z = gaussFunction(X,Y);
mesh(Z);
