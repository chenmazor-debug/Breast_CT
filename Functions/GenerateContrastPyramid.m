function [ContrastPyramid]= GenerateContrastPyramid(BlurredPyramid,N,gap)


ContrastPyramid = cell(1,N+1);

% Generating Contrast Pyramid
for i=1:N
    Ip = BlurredPyramid{i};
    Iexpand = BlurredPyramid{i+gap};
    for g= 1:gap
        Iexpand= (my_impyramid(Iexpand, 'expand'))+1e-9;
    end
    C = Ip./ Iexpand;
    %C = medfilt2(C,[3 3]);
    if(i == 2 || i==1  )
        C(C<0.95) = 0.95;
    end
    ContrastPyramid{i} = C;
    
   [max(C(:)) min(C(:))];

end


ContrastPyramid{N+1} = BlurredPyramid{N+1};
