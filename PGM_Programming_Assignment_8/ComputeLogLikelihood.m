function loglikelihood = ComputeLogLikelihood(P, G, dataset)
% returns the (natural) log-likelihood of data given the model and graph structure
%
% Inputs:
% P: struct array parameters (explained in PA description)
% G: graph structure and parameterization (explained in PA description)
%
%    NOTICE that G could be either 10x2 (same graph shared by all classes)
%    or 10x2x2 (each class has its own graph). your code should compute
%    the log-likelihood using the right graph.
%
% dataset: N x 10 x 3, N poses represented by 10 parts in (y, x, alpha)
% 
% Output:
% loglikelihood: log-likelihood of the data (scalar)
%
% Copyright (C) Daphne Koller, Stanford Univerity, 2012

N = size(dataset,1); % number of examples
K = length(P.c); % number of classes

loglikelihood = 0;
% You should compute the log likelihood of data as c =ain eq. (12) and (13)
% in the PA description
% Hint: Use lognormpdf instead of log(normpdf) to prevent underflow.
%       You may use log(sum(exp(logProb))) to do addition in the original
%       space, sum(Prob).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if size(size(G),2) == 2
	G1 = G; G2 = G;
else
	G1 = reshape(G(:,:,1),10,2);
	G2 = reshape(G(:,:,2),10,2);
end

for n=1:N,
	log1p = log(P.c(1));
	log2p = log(P.c(2));
	for j=1:10,
		if G(j,1) == 0,
			log1p += lognormpdf(dataset(n,j,1),P.clg(j).mu_y(1),P.clg(j).sigma_y(1));
			log1p += lognormpdf(dataset(n,j,2),P.clg(j).mu_x(1),P.clg(j).sigma_x(1));
			log1p += lognormpdf(dataset(n,j,3),P.clg(j).mu_angle(1),P.clg(j).sigma_angle(1));
			
			log2p += lognormpdf(dataset(n,j,1),P.clg(j).mu_y(2),P.clg(j).sigma_y(2));
			log2p += lognormpdf(dataset(n,j,2),P.clg(j).mu_x(2),P.clg(j).sigma_x(2));
			log2p += lognormpdf(dataset(n,j,3),P.clg(j).mu_angle(2),P.clg(j).sigma_angle(2));
			
		else
			parentId = G(j,2);
			mu_y1p = P.clg(j).theta(1,1) + dataset(n,parentId,1) * P.clg(j).theta(1,2) + dataset(n,parentId,2) * P.clg(j).theta(1,3) + dataset(n,parentId,3) * P.clg(j).theta(1,4);
			mu_x1p = P.clg(j).theta(1,5) + dataset(n,parentId,1) * P.clg(j).theta(1,6) + dataset(n,parentId,2) * P.clg(j).theta(1,7) + dataset(n,parentId,3) * P.clg(j).theta(1,8);
			mu_angle1p = P.clg(j).theta(1,9) + dataset(n,parentId,1) * P.clg(j).theta(1,10) + dataset(n,parentId,2) * P.clg(j).theta(1,11) + dataset(n,parentId,3) * P.clg(j).theta(1,12);
			
			mu_y2p = P.clg(j).theta(2,1) + dataset(n,parentId,1) * P.clg(j).theta(2,2) + dataset(n,parentId,2) * P.clg(j).theta(2,3) + dataset(n,parentId,3) * P.clg(j).theta(2,4);
			mu_x2p = P.clg(j).theta(2,5) + dataset(n,parentId,1) * P.clg(j).theta(2,6) + dataset(n,parentId,2) * P.clg(j).theta(2,7) + dataset(n,parentId,3) * P.clg(j).theta(2,8);
			mu_angle2p = P.clg(j).theta(2,9) + dataset(n,parentId,1) * P.clg(j).theta(2,10) + dataset(n,parentId,2) * P.clg(j).theta(2,11) + dataset(n,parentId,3) * P.clg(j).theta(2,12);
			
			log1p += lognormpdf(dataset(n,j,1), mu_y1p, P.clg(j).sigma_y(1));
			log1p += lognormpdf(dataset(n,j,2), mu_x1p, P.clg(j).sigma_x(1));
			log1p += lognormpdf(dataset(n,j,3), mu_angle1p, P.clg(j).sigma_angle(1));
			
			
			log2p += lognormpdf(dataset(n,j,1), mu_y2p, P.clg(j).sigma_y(2));
			log2p += lognormpdf(dataset(n,j,2), mu_x2p, P.clg(j).sigma_x(2));
			log2p += lognormpdf(dataset(n,j,3), mu_angle2p ,P.clg(j).sigma_angle(2));
			
		end	
	end
	loglikelihood += log(exp(log1p)+exp(log2p));
end




