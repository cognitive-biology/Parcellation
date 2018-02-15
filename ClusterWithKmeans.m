function [Idx, Tidx, nc,r_th,z_th] = ClusterWithKmeans( r,z,n,th,varargin)
% Performs kmean clustering on a set of data after with a predefined
% threshold.
%
% CLUSTERWITHKMEANS(RHO,PVAL,N,TH,Z) gets the data RHO, its p-values
% PVAL and the Fisher's Transformed z-score Z, and classifies the data into 
% N differentclusters. Only the data which has p-values less than threshold
%  TH are assigned to a cluster.
%
% [IDX,TIDX,NC,RHO_TH] = CLUSTERWITHKMEANS(RHO,PVAL,N,TH,Z) gives the cluster index IDX
% to each row of the data RHO, index of clusters for the data with only
% significant values TIDX, number of clusters NC and the output correlation after
% thresholding.
%
% CLUSTERWITHKMEANS(RHO,PVAL,N,TH,Property1) initializes property
%   Property1.
%   Admissible propertiy is:
%       threshold   -  apply threshold (default 1) [if 0 RHO is already thresholded]
%
% See also kmeans, threshold .
%
% E. Kakaei, J. V. Dornas, J. Braun 2018
apply = 1;
for id = 1:2:length(varargin)
    switch varargin{id}
        case 'threshold'
            apply = varargin{id}+1;
    end
    
end
% thresholding style


nVoxels = size(data,1); % number of voxels

% applying threshold or not
if apply
    [r_th,z_th] = threshold(r,z,th);
else
    r_th = r;
    z_th = z;
end
clear data data_th pval rho

% find NaNs
kk = find(~any(r_th,2));
tmp = r_th;
tmp(kk,:) = [];
tmp(:,kk) = [];

%% compute the clusters

Tidx = kmeans(tmp, n , 'distance', 'correlation', 'display', 'off','replicate',20); %,'Options',statset('UseParallel',1));
nc = max(Tidx);

%% repositions voxels clusters with NaNs

Idx = zeros(nVoxels,1);
ik = 0;

for iVoxel=1:nVoxels
    if find(kk==iVoxel)
        Idx(iVoxel) = NaN;
    else
        ik = ik + 1;
        Idx(iVoxel) = Tidx(ik);
    end
end

end