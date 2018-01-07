%COMPUTEEXACTMARGINALSBP Runs exact inference and returns the marginals
%over all the variables (if isMax == 0) or the max-marginals (if isMax == 1). 
%
%   M = COMPUTEEXACTMARGINALSBP(F, E, isMax) takes a list of factors F,
%   evidence E, and a flag isMax, runs exact inference and returns the
%   final marginals for the variables in the network. If isMax is 1, then
%   it runs exact MAP inference, otherwise exact inference (sum-prod).
%   It returns an array of size equal to the number of variables in the 
%   network where M(i) represents the ith variable and M(i).val represents 
%   the marginals of the ith variable. 
%
% Copyright (C) Daphne Koller, Stanford University, 2012


function M = ComputeExactMarginalsBP(F, E, isMax)

% initialization
% you should set it to the correct value in your code

len = length(F);
M = repmat(struct('var', [], 'card', [], 'val', []), len, 1);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%
% Implement Exact and MAP Inference.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

P = CreateCliqueTree(F, E);

P = CliqueTreeCalibrate(P, isMax);

var = [];
for i=1:length(P.cliqueList)
	var = union(var, P.cliqueList(i).var);
end

for i=1:length(var);
	for j=1:length(P.cliqueList);
		tf = ismember(var(i), P.cliqueList(j).var);
		if (tf);
			if isMax
				M(var(i)) = FactorMaxMarginalization(P.cliqueList(j), setdiff(P.cliqueList(j).var, var(i)));
			else
				M(var(i)) = FactorMarginalization(P.cliqueList(j), setdiff(P.cliqueList(j).var, var(i)));
				M(var(i)).val = M(var(i)).val ./ sum(M(var(i)).val);
			endif
			break;
		end
	end
end
end
