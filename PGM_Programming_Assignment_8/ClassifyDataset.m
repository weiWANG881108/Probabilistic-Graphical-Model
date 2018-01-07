function accuracy = ClassifyDataset(dataset, labels, P, G)
% returns the accuracy of the model P and graph G on the dataset 
%
% Inputs:
% dataset: N x 10 x 3, N test instances represented by 10 parts
% labels:  N x 2 true class labels for the instances.
%          labels(i,j)=1 if the ith instance belongs to class j 
% P: struct array model parameters (explained in PA description)
% G: graph structure and parameterization (explained in PA description) 
%
% Outputs:
% accuracy: fraction of correctly classified instances (scalar)
%
% Copyright (C) Daphne Koller, Stanford Univerity, 2012

N = size(dataset, 1);
accuracy = 0.0;

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
	calclabels(n,:) = [log1p,log2p];
end

[temp,temp1] = max(calclabels,[],2);
[temp,temp2] = max(labels,[],2);
accuracy = sum(temp1==temp2)/N;

fprintf('Accuracy: %.2f\n', accuracy);