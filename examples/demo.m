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
atlas_nii = fullfile('..','atlas','aal','ROI_MNI_V4.nii'); % path to atlas nifti file
ROI = fullfile('..','atlas','aal','ROI_MNI_V4_List.mat'); % path to list of ROI
nfiles = 2; 
for n = 1:nfiles
imagepath = fullfile('.','Example_Data',['example',num2str(n),'.nii']); % path to images
save_image_name = ['example',num2str(n)];

out_data = img2atlas(atlas_nii,ROI,imagepath,'save',save_image_name);

images(n).out_data = out_data; % data of all images
end

%% local correlation
TR_range = 17:166; % TRs used for analysis
region = 65; % region code (e.g. 65 for Angular L)
save_correlation_name = fullfile('.','Example_Data','correlation_profile');

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

%% Plots
% sorting by cluster
R1 = rho{1};
R2 = rho{2};
index = cell(1,nc);
for kk = 1:nc
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
title('example 1')

subplot(2,2,2)
surf(R2,'EdgeColor','none');view(2);axis equal; axis ij; axis off
title('example 2')

subplot(2,2,3)
surf(Rsort1,'EdgeColor','none');view(2);axis equal; axis ij; axis off
title('example 1 sorted')

subplot(2,2,4)
surf(Rsort2,'EdgeColor','none');view(2);axis equal; axis ij; axis off
title('example 2 sorted')