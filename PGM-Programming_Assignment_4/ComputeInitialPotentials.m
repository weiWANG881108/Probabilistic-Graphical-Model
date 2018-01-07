%COMPUTEINITIALPOTENTIALS Sets up the cliques in the clique tree that is
%passed in as a parameter.
%
%   P = COMPUTEINITIALPOTENTIALS(C) Takes the clique tree skeleton C which is a
%   struct with three fields:
%   - nodes: cell array representing the cliques in the tree.
%   - edges: represents the adjacency matrix of the tree.
%   - factorList: represents the list of factors that were used to build
%   the tree. 
%   
%   It returns the standard form of a clique tree P that we will use through 
%   the rest of the assigment. P is struct with two fields:
%   - cliqueList: represents an array of cliques with appropriate factors 
%   from factorList assigned to each clique. Where the .val of each clique
%   is initialized to the initial potential of that clique.
%   - edges: represents the adjacency matrix of the tree. 
%
% Copyright (C) Daphne Koller, Stanford University, 2012


function P = ComputeInitialPotentials(C)

% number of cliques
N = length(C.nodes)

% initialize cluster potentials 
P.cliqueList = repmat(struct('var', [], 'card', [], 'val', []), N, 1);
P.edges = zeros(N, N);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%
% First, compute an assignment of factors from factorList to cliques. 
% Then use that assignment to initialize the cliques in cliqueList to 
% their initial potentials. 

% C.nodes is a list of cliques.
% So in your code, you should start with: P.cliqueList(i).var = C.nodes{i};
% Print out C to get a better understanding of its structure.
%

%give the value of P.edges

P.edges = C.edges;
M = length(C.factorList)
assigned = zeros(1,M);
for i=1:N;
%	P.cliqueList(i).var = C.nodes{i};

	for j=1:M;
		[td, s_idx] = ismember(C.factorList(j).var, C.nodes{i});
		if (all(td));
			if(~assigned(j));
				assigned(j) = i;
%				P.cliqueList(i).card(s_idx) = C.factorList(j).card;
			end
		end
	end
end

for i=1:M;
	P.cliqueList(assigned(i)) = FactorProduct(P.cliqueList(assigned(i)), C.factorList(i));
end

%for i=1:N;
%	num = length(C.nodes{i});
%	[V1, map1] = setdiff(C.factorList(C.nodes{i}(1)).var, C.nodes{i});
%	temp = FactorMarginalization(C.factorList(C.nodes{i}(1)),V1);
%	% normalization
%	temp.val = temp.val ./ sum(temp.val);
%	for j=2:num;
%		[V, map] = setdiff(C.factorList(C.nodes{i}(j)).var, C.nodes{i});
%		B = FactorMarginalization(C.factorList(C.nodes{i}(j)),V);
%		B.val = B.val ./ sum(B.val);
%		temp = FactorProduct(temp, B);
%	end
%	P.cliqueList(i) = temp;
%end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end

