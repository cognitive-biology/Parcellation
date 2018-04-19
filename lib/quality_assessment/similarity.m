function [S,D,CH,SC] = similarity(rho,clusters)
% calculates the similarity, dissimilarity, cluster homogeneity and
% Silhouette coefficient.
%
% [S,D,CH,SC] = SIMILARITY(RHO,CLUSTERS) gets the correlation/z-score profile 
% RHO and the cluster indices CLUSTERS, and outputs the similarity S,
% dissimilarity D, cluster homogeneity CH and Silouette coefficient SC.

MIN_READOUT = realmin; % Smallest positive number (to be assigned for INF similarity)
nc = length(unique(clusters)); % number of clusters
R = corr(transpose(rho));
D = 1-R; % dissimilarity
tmp = R(:);
S = 0.5*log((1+tmp)./(1-tmp));
S = reshape(S,size(R)); % similarity
S(S==inf) = MIN_READOUT;

%% cluster homogeneity and Silhouette coefficient
CH = cell(nc,1);
SC = cell(nc,1);
for ind = 1:nc
    clear tmpS
    
    index = clusters==ind;
    tmpS = S(index,:);
    tmpS = tmpS(:,index);
    
    tmpB = D(index,:); 
    tmpB = tmpB(:,~index); % voxels out of the cluster
    
    tmpA = D(index,:);
    tmpA = tmpA(:,index);
    
    A = mean(tmpA,2);
    B = mean(tmpB,2);
    SC{ind} = (B-A)/max([A;B]); % Silhouette coefficient
    CH{ind} = mean(tmpS,2); % cluster homogeneity
    
end
CH = cell2mat(CH);
SC = cell2mat(SC);
end