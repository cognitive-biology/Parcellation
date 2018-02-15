function [rho,pval,zscore] = local_corr(region,lag,varargin)
% LOCAL_CORR() finds the correlation matrix and p-values assigned to it
% along with the Fisher transformed values.
%
% [RHO,PVAL,ZSCORE] = LOCAL_CORR(REGION,LAG) Generates the correlation matrix
% RHO of the selected image(s), transformed to the desired atlas, for the
% region code REGION which can be found in atlas list . The function also
% outputs the p-values PVAL assigned to them, as well as their Fisher transformed
% values ZSCORE.
%
% IMG2ATLAS(REGION,LAG,Property1,Value1) initializes property
%   Property1 to Value1.
%   Admissible properties are:
%       save     -   file name to save
%       data     -   data to import
%       path     -   path to all files (should contain only necessary .mat files)
%
% See also corr, img2atlas .
%
% E. Kakaei, J. V. Dornas, J. Braun 2018

%% initialize
save_file = false;
data = '';
pathname = '';
for n = 1:2:length(varargin)-1
    switch varargin{n}
        case 'save'
            save_file = varargin{n+1};
            if ~ischar(save_file)
                error('file name should be character')
            end
        case 'data'
            data = varargin{n+1};
        case 'path'
            pathname = varargin{n+1};
    end
end

if isempty(data) && isempty(pathname)
    % get single/multiple image files
    [filename,pathname] = uigetfile('*.mat','Select atlas_fitted images','MultiSelect','on');
    n_files = size(filename,2);
    if ischar(filename) % if only one file is selected
        n_files = 1;
        filename = {filename};
    end
    for ind = 1:n_files
        % load data
        data(ind) = load(strcat(pathname,filename{ind}));
    end
elseif ~isempty(pathname)
    % get files from the desired folder
    filename = dir([pathname '*.mat']);
    
    % for mac OS
    index = [];
    for fn = 1:length(filename)
        if filename(fn).name(1) == '.'
            index = [index fn];
        end
    end
    filename(index) = [];
    
    filename = {filename.name};
    n_files = size(filename,2);
    for ind = 1:n_files
        % load data
        data(ind) = load(strcat(pathname,filename{ind}));
    end
else
    % data has been imported directly
    n_files = length(data);
    pathname = '';
end

%% Local corr. calculation
zscore = cell(1,n_files); % Fisher transformed correlation
pval = cell(1,n_files); % P-value
rho = cell(1,n_files); % correlation

for ind = 1:n_files
    disp([num2str(round(100*ind/n_files)) '%'])
    
    out_data = data(ind).out_data;
    
    out_data{region,2}(ismember(out_data{region,2},'_')) = ''; % changing _ into space in name tag
    
    tmp = cell2mat(out_data(region+1,4)); % +1 is if the first region code is 0 (regions out of atlas)
    tmp = tmp(lag+1:end,:);
    [r,p] = corr(tmp);
    B = r(:);
    Z = 0.5*log((1+B)./(1-B)); % Fisher Transformation
    Z = reshape(Z,size(r));
    
    zscore{ind} = Z;
    rho{ind} = r;
    pval{ind} = p;
end
%% save file
if save_file
    %     mkdir ([pathname '/local_corr'])
    matfile = fullfile(pathname, [save_file '.mat']);
    save(matfile,'rho','pval','zscore','-v7.3')
end
end