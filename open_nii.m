function [data,FileName,PathName] = open_nii(varargin)
% OPEN_NII() opens files with .nii format using the NifTI Toolbox
% (nifti.nimh.nih.gov/nifti-1/). Please download it and include it in the
% path.
%
% [DATA,FILENAME,PATHNAME] = OPEN_NII() outputs the data DATA of a file with .nii format
% and provides the file name FILENAME and path PATHNAME of the selected
% file. MSG is the massage shown on the opening window.
%
% OPEN_NII(Property1,Value1) initializes property
%   Property1 to Value1.
%   Admissible properties are:
%       msg     -   message written on the opening window
%       file    -   file path
%
% See also nifti
%
% E. Kakaei, J. V. Dornas, J. Braun 2018

switch computer
    case {'PCWIN' ,'PCWIN64'}
        symbol = '\'; % path style in Windows
    case {'MACI64' ,'MACI'}
        symbol = '/'; % path style in OS
end
% default
msg = 'Select desired nifti file';
address = '';

for n = 1:1:length(varargin)-1
    switch varargin{n}
        case 'msg'
            msg = varargin{n+1};
        case 'file'
            address = varargin{n+1};
    end
end

if isempty(address)
    [FileName,PathName] = uigetfile('*.nii',msg);
    if ischar(FileName) || ischar(PathName)
        address = strcat(PathName,FileName);
        data = nifti(address);
    else
        error('a valid file should be selected')
    end
else
    if ischar(address)
        data = nifti(address);
        crind = strfind(address,symbol);
        FileName = address(crind(end)+1:end);
        PathName = address(1:crind(end));
    else
        error('a valid file should be selected')
    end
    
end
end
