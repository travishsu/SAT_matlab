function Initial = LHD(numInitial, numDim, window)
%> @file LHD.m
%=================================================
%> @brief Latin hypercube design sampling
%>
%> For numDim-dimensional region bounded in window, generate a 
%> Latin-Hypercube Design 
%> 
%> @param numInitial Integer number, number of designs
%> @param numDim     Integer number, dimension of designs
%> @param window     1-by-2*numDim vector, region's edges in each dimension
%>         
%> @retval Initial   numInitial-by-numDim matrix, a design over region in window
%=================================================


lowerbound = zeros(numDim, 1);
upperbound = zeros(numDim, 1);

for i = 1:numDim
    lowerbound(i) = window(2*i-1);
    upperbound(i) = window(2*i);
end
    if numDim == 1
        Initial = linspace(lowerbound, upperbound, numInitial)';
        
    elseif numDim ~= 0
        Initial = bestlh(numInitial, numDim, 50, 25);
        
        lowerbound = dim_correction(lowerbound, 1, 0);
        upperbound = dim_correction(upperbound, 1, 0);
        
        for i = 1:size(lowerbound, 1)
            Initial(:, i) = Initial(:, i)*(upperbound(i)-lowerbound(i))+lowerbound(i);
        end
    end
    
end
        