%GETNEXTCLIQUES Find a pair of cliques ready for message passing
%   [i, j] = GETNEXTCLIQUES(P, messages) finds ready cliques in a given
%   clique tree, P, and a matrix of current messages. Returns indices i and j
%   such that clique i is ready to transmit a message to clique j.
%
%   We are doing clique tree message passing, so
%   do not return (i,j) if clique i has already passed a message to clique j.
%
%	 messages is a n x n matrix of passed messages, where messages(i,j)
% 	 represents the message going from clique i to clique j. 
%   This matrix is initialized in CliqueTreeCalibrate as such:
%      MESSAGES = repmat(struct('var', [], 'card', [], 'val', []), N, N);
%
%   If more than one message is ready to be transmitted, return 
%   the pair (i,j) that is numerically smallest. If you use an outer
%   for loop over i and an inner for loop over j, breaking when you find a 
%   ready pair of cliques, you will get the right answer.
%
%   If no such cliques exist, returns i = j = 0.
%
%   See also CLIQUETREECALIBRATE
%
% Copyright (C) Daphne Koller, Stanford University, 2012


function [i, j] = GetNextCliques(P, messages)

% initialization
% you should set them to the correct values in your code
i = 0;
j = 0;
N = length(P.cliqueList);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

readyToOut = 0;

for ii=1:N;
	for jj=1:N;
		if (P.edges(ii,jj) && isempty(messages(ii,jj).var));
			readyToOut = 1;
			for k=1:N;
				if k!=jj && (P.edges(k,ii) && isempty(messages(k,ii).var));
					readyToOut = 0;
					break;
				end
			end
			if (readyToOut == 1);
				i = ii;
				j = jj;
				return;
			end
		end
	end
end

%N = size(messages,1);
%ii = 0;
%jj = 0;
%for i = 1:N
%    for j = 1:N
%        if (P.edges(i,j) && isempty(messages(i,j).var))
%            readyToSend = 1;
%            for k = 1:N
%                if k ~= j && P.edges(k,i)
%                    if isempty(messages(k,i).var)
%                        readyToSend = 0;
%                        break;
%                    end
%                end
%            end
%            if readyToSend
%                ii = i;
%                jj = j;
%                return;
%            end
%        end
%    end
%end

return;
