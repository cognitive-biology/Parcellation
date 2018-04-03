function [Idx, Tidx, nc,Dis] = ClusterWithKmeans(r,n)
% CLUSTERWITHKMEANS performs kmean clustering on a set of data with a set 
% of pre-defined parameters.
%
% CLUSTERWITHKMEANS(R,N) gets the N-by-M data R and classifies the data  
% into N different clusters using correlation as the distance measure and
% 20 replicates. Insignificant voxels have NaN assigned as their index of
% the cluster.
%
% [IDX,TIDX,NC,DIS] = CLUSTERWITHKMEANS(R,N) gives the cluster indices IDX
% (N-by-1) to each row of the data R, index of clusters for the data with
% only significant values TIDX (P-by-1), number of clusters NC and  
% distances DIS (P-by-NC) from each point to every centroid of the clusters.
%
% See also kmeans, threshold.
%
% J. V. Dornas, E. Kakaei, J. Braun 2018

nVoxels = size(r,1); % number of voxels

% find NaNs
kk = find(~any(r,2));
r(kk,:) = [];
r(:,kk) = [];

%% compute the clusters
fprintf('kmean clustering started ... \n')
[Tidx,~,~,Dis] = kmeans(r,n,'distance','correlation','display','off','replicate',20);
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
fprintf('done!\n')
end