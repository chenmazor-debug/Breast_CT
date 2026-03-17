function GammaPyrmaid = CalculteGamma(SorfPyramid,GammaParams,ContrastPyramid,ModulationPyramid)
N = length(SorfPyramid);
GammaPyrmaid = cell(1,N);
for i = 1:N
    max(SorfPyramid{i}(:));
    
    SorfPyramid{i} = medfilt2(SorfPyramid{i},[3 3]);    
   
    S = (SorfPyramid{i});
    max(SorfPyramid{i}(:));
    C=ContrastPyramid{i};
   
    maxC = max(C(:));
    minC = min(C(:));
    c =  (maxC - minC);
   
    if(i+2 <= N+1)
        I = my_impyramid(my_impyramid(ModulationPyramid{i+2}, 'expand'),'expand');
    else
        I = my_impyramid(ModulationPyramid{i+1}, 'expand');
    end    
    
     if i == 5
        GammaParams{i}.c = 5;
        l1 = 15; 
        l2 = 5; 
        GammaParams{i}.c = 0.05.*(l2.*I+(1-I).*l1);
    elseif i == 4         
        GammaParams{i}.c = 1;
        l1 = 15;
        l2 = 5;
        % GammaParams{i}.c =l2.*I+(1-I).*l1;
    elseif i == 3       
        GammaParams{i}.c = 15;
        l1 = 15;
        l2 = 5;
        %GammaParams{i}.c =l2.*I+(1-I).*l1;
     elseif i == 2        %%% for large lesion
         GammaParams{i}.c = 35;
         l1 = 300; 
         l2 = 30;
         GammaParams{i}.c =l2.*I+(1-I).*l1;
    elseif i == 1      
        GammaParams{i}.c =55;
        l1 = 300;
        l2 = 100;
        GammaParams{i}.c =l2.*I+(1-I).*l1;% (30-5);
      
    else
       GammaParams{i}.c = 1;
        l1 = 45;
        l2 = 15;
        GammaParams{i}.c =l2.*I+(1-I).*l1;
    end
    
    SMod = (max(S(:)) - 1*S);
     
    SNorm = (SMod) + 1e-9;
    SAbs = abs(SMod);
    
    GammaPyrmaid{i} =GammaParams{i}.c.*SNorm;

end
