% this demo performs functional clustering on 2 example fMRI images for a
% desired region (Angular L), after fitting them into a desired atlas
% (AAL90), calculating their correlation profile and thresholding them
% by eliminating the insignificant  correlations and inconsistently
% significant correlations.
% Finally, the native and sorted correlation matrices are ploted.
clear all;
close all;
clc

addpath(genpath(fullfile('..','lib')))
%% fitting to atlas
atlasnii = fullfile('.','Example_Atlas','exampleatlas.nii'); % path to atlas nifti file
atlaslist = fullfile('.','Example_Atlas','exampleatlas_List.mat'); % path to list of ROI
nfiles = 2;
for n = 1:nfiles
    imagepath = fullfile('.','Example_Data',['exampledata',num2str(n),'.nii']); % path to images
    save_image_name = ['example',num2str(n),'_atlas_fitted'];
    
    out_data = img2atlas(atlasnii,atlaslist,imagepath,'save',save_image_name);
    
    images(n).out_data = out_data; % data of all images
end

%% local correlation
TR_range = 17:166; % TRs used for analysis

for region = 1:2 % region code (e.g. 1 for Angular L)
    
    save_correlation_name = fullfile('.','Example_Data',['correlation_profile'...
        ,num2str(region)]);
    
    [rho,pval,zscore] = local_corr(region,images,TR_range,'save',save_correlation_name);
    
    %% Thresholding
    th = 0.13; % threshold limit
    R = cell2mat(rho);
    Z = cell2mat(zscore);
    
    [R_th,Z_th,insignificant_index] = threshold(R,Z,th);
    
    %% clustering
    nvoxels = size(R,1);
    voxel_per_cluster = 200;
    nclusters = floor(nvoxels/voxel_per_cluster);
    [Idx, Tidx, nc,Dis] = ClusterWithKmeans(R_th,nclusters);
    save(fullfile('.','Example_Data',['cluster' num2str(region)]),'Idx')
    clusters(region) = {fullfile('.','Example_Data',['cluster' num2str(region)])};
end
%% save atlas list and nifti
[atlas_data,ROI] = cluster2atlas(clusters,atlasnii,atlaslist,1:2 ...
    ,'save','example_atlas','nii','example_atlas.nii');
%% Plots
% sorting by clusters
load(fullfile('.','Example_Data',['correlation_profile',num2str(1),'_rho']));
load(fullfile('.','Example_Data',['cluster' num2str(1)]))

R1 = rho{1};
R2 = rho{2};
index = cell(1,max(Idx));
for kk = 1:max(Idx)
    index{1,kk} = find(Idx==kk);
end
A_all = cat(1,index{:});
Rsort1 = R1(:,A_all);
Rsort1 = Rsort1(A_all,:);

Rsort2 = R2(:,A_all);
Rsort2 = Rsort2(A_all,:);

figure
subplot(2,2,1)
surf(R1,'EdgeColor','none');view(2);axis equal; axis ij; axis off
title('native example data 1')

subplot(2,2,2)
surf(R2,'EdgeColor','none');view(2);axis equal; axis ij; axis off
title('native example data 2')

subplot(2,2,3)
surf(Rsort1,'EdgeColor','none');view(2);axis equal; axis ij; axis off
title('example data 1 sorted by clusters')

subplot(2,2,4)
surf(Rsort2,'EdgeColor','none');view(2);axis equal; axis ij; axis off
title('example data 2 sorted by clusters')