function out_data = img2atlas(varargin)
% IMG2ATLAS() finds regions to which voxels of an image blong, for a given
% atlas.
%
% OUT_DATA = IMG2ATLAS() gets the atlas and image file and outputs the
% OUT_DATA which contains the region code and names, index of voxels in each region
% and their values/time series. 
%
% IMG2ATLAS(Property1,Value1) initializes property
%   Property1 to Value1.
%   Admissible properties are:
%       save     -   file name to save
%       atlas    -   path to the atlas nifti file
%       list     -   path to the list of regions in .mat format
%       image    -   path to the image nifti file
%
% See also open_nii, local_corr .
%
% E. Kakaei, J. V. Dornas, J. Braun 2018

%% import
save_file = false;
atlas_name = '';
region = '';
image = '';
for n = 1:1:length(varargin)-1
    switch varargin{n}
        case 'save'
            save_file = varargin{n+1};
            if ~ischar(save_file)
                error('file name should be character')
            end
        case 'atlas'
            atlas_name = varargin{n+1};
        case 'list'
            region = varargin{n+1};
        case 'image'
            image = varargin{n+1};
    end
end

atlas = open_nii('file',atlas_name,'msg','Select your atlas file (*.nii)'); % nifti file of atlas
[img,~,img_path]= open_nii('file',image,'msg','Select your image file (*.nii)'); % image file

if isempty(region)
    [region_name,region_path] = uigetfile('*.mat','Select atlas list of regions'); % list of regions
    region = strcat(region_path,region_name);
end
load(region) % load list of atlas names (ROI)


atlas_data = atlas.dat();
atlas_size = size(atlas_data);

data = img.dat;
data_size = size(data);
atlas_vec = atlas_data(:);
data_vec = data(:);
% check
if atlas_size(1:3)~=data_size(1:3)
    error('image file and atlas file does not have same dimension')
end

atlas_regions = unique(atlas_data);
out_data = cell(length(atlas_regions),4); %{code name voxels_index voxels_data}

for ind = 1:length(atlas_regions)
    disp([num2str(round(100*ind/length(atlas_regions))) '%'])
    
    ID_index = find(atlas_vec==atlas_regions(ind));
    name_index = find([ROI.ID]== atlas_regions(ind));
    
    if length(name_index)>1
        error('Problem with atlas. ID mismatch') % name
    elseif ~isempty(name_index)
        out_data{ind,2} = ROI(name_index).Nom_L;
    else
        out_data{ind,2} = '';
    end
    
    out_data{ind,1} = atlas_regions(ind); % region code
    out_data{ind,3} = ID_index; % voxels in region(ind)
    reg_data = zeros(size(data,4),length(ID_index));
    tmp_index = ID_index;
    % time series
    for t = 1:size(data,4)
        reg_data(t,:) = data_vec(tmp_index);
        tmp_index = tmp_index+length(atlas_vec);
    end
    out_data{ind,4} = reg_data;
end
%% save file
if save_file
    matfile = fullfile(img_path, [save_file '.mat']);
    save(matfile,'out_data')
end

end