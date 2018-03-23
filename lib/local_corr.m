function [rho,pval,zscore] = local_corr(region,images,range,varargin)
% LOCAL_CORR calcuates the correlation matrix and p-values assigned to it
% along with the Fisher Z-transformed values.
%
% [RHO,PVAL,ZSCORE] = LOCAL_CORR(REGION,IMAGES,RANGE) Generates 1-by-N
% cell arrays RHO, PVAL and ZSCORE which contain the correlation
% matrices, their corresponding p-value and Fisher Z-transformed form,
% respectively, for a desired region REGION of the atlas-fitted IMAGES 
% (1-by-N structure array) for the TR range RANGE.
%
% IMG2ATLAS(REGION,IMAGES,RANGE,Property1,Value1) initializes property
%   Property1 to Value1.
%   Admissible property:
%       save     -   file name to save
%
% See also corr, img2atlas, threshold. 
%
% J. V. Dornas, E. Kakaei, J. Braun 2018

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

%% Local corr. calculation
zscore = cell(1,n_files); % Fisher Z-transformed correlation
pval = cell(1,n_files); % P-value
rho = cell(1,n_files); % correlation

for ind = 1:n_files
    fprintf(['calculating correlation profile: ',num2str(ind),' out of ',...
        num2str(n_files),' ...\n'])
    out_data = images(ind).out_data;
    non_atlas = out_data{1,1}==0; % check for regions out of atlas
    
    % +1 is if the first region code is 0 (regions out of atlas)
    tmp = cell2mat(out_data(region+non_atlas,4)); 
    tmp = tmp(range,:); % keeping only TRs within range
    [R,p] = corr(tmp);
    B = R(:);
    Z = 0.5*log((1+B)./(1-B)); % Fisher Transformation
    Z = reshape(Z,size(R));
    
    zscore{ind} = Z;
    rho{ind} = R;
    pval{ind} = p;
end
%% save file
if save_file
    save(strcat(save_file,'_rho'),'rho','-v7.3')
    save(strcat(save_file,'_pval'),'pval','-v7.3')
    save(strcat(save_file,'_zscore'),'zscore','-v7.3')
end
end