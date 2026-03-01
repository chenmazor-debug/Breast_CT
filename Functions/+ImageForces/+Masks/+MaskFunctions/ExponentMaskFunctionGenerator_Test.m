ro = 10;
expFunction = ImageForces.Masks.MaskFunctions.ExponentMaskFunctionGenerator(ro);
[X, Y] = meshgrid(-ro:ro,-ro:ro);
Z = expFunction(X,Y);
mesh(Z);
