function [snr_t,mu_t,sigma_t] = tsnr(regions,images,range,varargin)

%% initialize
save_file = false;
for n = 1:2:length(varargin)-1
    switch varargin{n}
        case 'save'
            save_file = varargin{n+1};
            if ~ischar(save_file)
                error('file name should be character')
            end
    end
end
% import data manually
n_files = length(images);
for ind = 1:n_files
    fprintf(['calculating signal to noise ratio: ',num2str(ind),' out of ',...
        num2str(n_files),' ...\n'])
    out_data = images(ind).out_data;
    non_atlas = out_data{1,1}==0; % check for regions out of atlas
    
    % +1 is if the first region code is 0 (regions out of atlas)
    tmp = out_data(regions+non_atlas,4);
    tmp = [tmp{:}];
    tmp = tmp(range,:); % keeping only TRs within range
    std_voxels(n_files,:) = std(tmp);
    mean_voxels(n_files,:) = mean(tmp);
end

sigma_t = std_voxels(:);
mu_t = mean_voxels(:);
snr_t = mu_t ./ sigma_t;

mu_t = mean_voxels;
sigma_t = std_voxels;
snr_t = reshape(snr_t,size(std_voxels));
end