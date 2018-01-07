% File: EM_cluster.m
%
% Copyright (C) Daphne Koller, Stanford Univerity, 2012

function [P loglikelihood ClassProb] = EM_cluster(poseData, G, InitialClassProb, maxIter)

% INPUTS
% poseData: N x 10 x 3 matrix, where N is number of poses;
%   poseData(i,:,:) yields the 10x3 matrix for pose i.
% G: graph parameterization as explained in PA8
% InitialClassProb: N x K, initial allocation of the N poses to the K
%   classes. InitialClassProb(i,j) is the probability that example i belongs
%   to class j
% maxIter: max number of iterations to run EM

% OUTPUTS
% P: structure holding the learned parameters as described in the PA
% loglikelihood: #(iterations run) x 1 vector of loglikelihoods stored for
%   each iteration
% ClassProb: N x K, conditional class probability of the N examples to the
%   K classes in the final iteration. ClassProb(i,j) is the probability that
%   example i belongs to class j

% Initialize variables
N = size(poseData, 1);
K = size(InitialClassProb, 2);

ClassProb = InitialClassProb;

loglikelihood = zeros(maxIter,1);

P.c = [];
P.clg.sigma_x = [];
P.clg.sigma_y = [];
P.clg.sigma_angle = [];

% EM algorithm
for iter=1:maxIter
  
  % M-STEP to estimate parameters for Gaussians
  %
  % Fill in P.c with the estimates for prior class probabilities
  % Fill in P.clg for each body part and each class
  % Make sure to choose the right parameterization based on G(i,1)
  %
  % Hint: This part should be similar to your work from PA8
  
  P.c = zeros(1,K);
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % YOUR CODE HERE
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  P.c = sum(ClassProb) / N;
  
  for i = 1:10,
  	if G(i,1) == 0,
  		for kk=1:K,
  			[P.clg(i).mu_y(kk), P.clg(i).sigma_y(kk)] = FitG(poseData(:,i,1), ClassProb(:,kk));
  			[P.clg(i).mu_x(kk), P.clg(i).sigma_x(kk)] = FitG(poseData(:,i,2), ClassProb(:,kk));
  			[P.clg(i).mu_angle(kk), P.clg(i).sigma_angle(kk)] = FitG(poseData(:,i,3), ClassProb(:,kk));
  		end
  	else
  		parentId = G(i,2);
  		for kk=1:K,
  			[BetaY, P.clg(i).sigma_y(kk)] = FitLG(poseData(:,i,1),reshape(poseData(:,parentId,:), N, 3),ClassProb(:,kk));
  			[BetaX, P.clg(i).sigma_x(kk)] = FitLG(poseData(:,i,2),reshape(poseData(:,parentId,:), N, 3),ClassProb(:,kk));
  			[Beta_angle, P.clg(i).sigma_angle(kk)] = FitLG(poseData(:,i,3),reshape(poseData(:,parentId,:), N, 3),ClassProb(:,kk));
  			P.clg(i).theta(kk,:) = [BetaY(4), BetaY(1:3)',BetaX(4), BetaX(1:3)', Beta_angle(4), Beta_angle(1:3)'];
  		end
  	end
  end
  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  % 'E-STEP to re-estimate ClassProb using the new parameters
  %
  % Update ClassProb with the new conditional class probabilities.
  % Recall that ClassProb(i,j) is the probability that example i belongs to
  % class j.
  %
  % You should compute everything in log space, and only convert to
  % probability space at the end.
  %
  % Tip: To make things faster, try to reduce the number of calls to
  % lognormpdf, and inline the function (i.e., copy the lognormpdf code
  % into this file)
  %
  % Hint: You should use the logsumexp() function here to do
  % probability normalization in log space to avoid numerical issues
  
  ClassProb = zeros(N,K);
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % YOUR CODE HERE
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
%  for i=1:N,
%  	ClassProb(i,:) = log(P.c);
%  	for j=1:10,
%  		if G(i,1) == 0,
%  			for kk=1:K,
%  					poseData(i,j,1)
%  					ClassProb(i,kk) += lognormpdf(poseData(i,j,1),P.clg(j).mu_y(kk),P.clg(j).sigma_y(kk));
%  					ClassProb(i,kk) += lognormpdf(poseData(i,j,2),P.clg(j).mu_x(kk),P.clg(j).sigma_x(kk));
%  					ClassProb(i,kk) += lognormpdf(poseData(i,j,3),P.clg(j).mu_angle(kk),P.clg(j).sigma_angle(kk));
%  			end
%  		else
%  			parentId = G(i,2);
%  			for kk=1:K,
%  					mu_yp = P.clg(j).theta(kk,1) + poseData(i,parentId,1) * P.clg(j).theta(kk,2) + poseData(i,parentId,2) * P.clg(j).theta(kk,3) + poseData(i,parentId,3) * P.clg(j).theta(kk,4);
%  					mu_xp =  P.clg(j).theta(kk,5) + poseData(i,parentId,1) * P.clg(j).theta(kk,6) + poseData(i,parentId,2) * P.clg(j).theta(kk,7) + poseData(i,parentId,3) * P.clg(j).theta(kk,8);
%  					mu_anglep = P.clg(j).theta(kk,9) + poseData(i,parentId,1) * P.clg(j).theta(kk,10) + poseData(i,parentId,2) * P.clg(j).theta(kk,11) + poseData(i,parentId,3) * P.clg(j).theta(kk,12);
%  					ClassProb(i,kk) +=  lognormpdf(poseData(i,j,1), mu_yp ,P.clg(j).sigma_y(kk));
%  					ClassProb(i,kk) +=  lognormpdf(poseData(i,j,2), mu_xp ,P.clg(j).sigma_x(kk));
%  					ClassProb(i,kk) +=  lognormpdf(poseData(i,j,3), mu_anglep ,P.clg(j).sigma_angle(kk));
%  			end
%  		end	
%  	end
%  end          
for i = 1:N
	  data = reshape(poseData(i,:,:),10,3);
	  ClassProb(i,:) = log(P.c);
	  for j = 1:10
		  if G(j,1) == 1
			  parent = data(G(j,2),:);
			  for k = 1:K
				  theta = P.clg(j).theta(k,:);
				  mu_y = sum(theta(1:4).*[1,parent]);
				  mu_x = sum(theta(5:8).*[1,parent]);
				  mu_a = sum(theta(9:12).*[1,parent]);
				  ClassProb(i,k) += lognormpdf(data(j,1),mu_y,P.clg(j).sigma_y(k));
				  ClassProb(i,k) += lognormpdf(data(j,2),mu_x,P.clg(j).sigma_x(k));
				  ClassProb(i,k) += lognormpdf(data(j,3),mu_a,P.clg(j).sigma_angle(k));
			  end
		  else
			  for k = 1:K
				  ClassProb(i,k) += lognormpdf(data(j,1),P.clg(j).mu_y(k),P.clg(j).sigma_y(k));
				  ClassProb(i,k) += lognormpdf(data(j,2),P.clg(j).mu_x(k),P.clg(j).sigma_x(k));
				  ClassProb(i,k) += lognormpdf(data(j,3),P.clg(j).mu_angle(k),P.clg(j).sigma_angle(k));
			  end
		  end
	  end
  end
 
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  % Compute log likelihood of dataset for this iteration
  % Hint: You should use the logsumexp() function here
  loglikelihood(iter) = 0;
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % YOUR CODE HERE
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  lse = logsumexp(ClassProb);
  loglikelihood(iter) = sum(lse);
  ClassProb = exp(ClassProb - lse);
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  % Print out loglikelihood
  disp(sprintf('EM iteration %d: log likelihood: %f', ...
    iter, loglikelihood(iter)));
  if exist('OCTAVE_VERSION')
    fflush(stdout);
  end
  
  % Check for overfitting: when loglikelihood decreases
  if iter > 1
    if loglikelihood(iter) < loglikelihood(iter-1)
      break;
    end
  end
  
end

% Remove iterations if we exited early
loglikelihood = loglikelihood(1:iter);
