close all;
clear all;
clc

lag = 15; % TR lag
vox_per_clust = 200; % number of average voxels per cluster
th = 0.13; % threshold

% %% load
% [filename,pathname] = uigetfile('*.mat','Select atlas_fitted images','MultiSelect','on');
% n_files = size(filename,2);
% if ischar(filename) % if only one file is selected
%     n_files = 1;
%     filename = {filename};
% end
% for ind = 1:n_files
%     % load data
%     data(ind) = load(strcat(pathname,filename{ind}));
% end


%% calculations
tic
for reg = 1:90
    reg
%     %% calculating local corrolations
%     coor_t = tic;
%     [rho,pval,zscore] = local_corr(reg,lag,'data',data,'save',['reg' num2str(reg)]);
%     toc(coor_t)
    R = cell2mat(rho);
    P = cell2mat(pval);
    Z = cell2mat(zscore);

    nVox = size(R,1);
    nClust = floor(nVox/200);
    
    %% clustering
    kmean_T = tic;
    [Idx, ~, nc,~] = ClusterWithKmeans( R, Z, nClust,th,'threshold',0);
    toc(kmean_T)

    %% analysis
    sim_t = tic;
    [S,D,CH,SC] = similarity(rho_th,Idx);
    toc(sim_t)

    save(strcat('results',num2str(reg),'.mat'),'S','D','CH','SC','Idx','-v7.3')
end
final_time = toc