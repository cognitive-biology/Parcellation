function [r_th,z_th,index] = threshold(r,z,th)
% THRESHOLD gets the correlations and Fisher Z-transformed correlation 
% matrix and applies the threshold on them.
%
% [R_TH,Z_TH,INDEX] = THRESHOLD(R,Z,TH) gets N-by-M correlation and Fisher 
% Z-transformed matrices R and Z and applies the threshold TH on 
% them. Finally, the thresholded correlation and FisherZ-transformed 
% matrices R_TH and Z_TH (N-by-M) are generated and the indices of 
% insignificant arrays INDEX (N-by-N) are given as output.
%
% See also local_corr, ClusterWithKmeans.
%
% J. V. Dornas, E. Kakaei, J. Braun 2018

MIN_READOUT = realmin; % Smallest positive number 

z(isinf(z)) = NaN;
dim = size(r); % dimension of the corralation matrix
tmp = reshape(z,dim(1),dim(1),dim(2)/dim(1));
mu = abs(nanmean(tmp,3)); % average z over sessions
sigma = nanstd(tmp,1,3); % standard deviation of z over sessions
mu(isnan(mu)) = MIN_READOUT;
sigma(isnan(sigma)) = MIN_READOUT;
cv = sigma./mu; % coefficient of variation
index = or(mu <= th, cv>=1); % insignificance/inconsistence criterion
clear sigma mu cv
r(repmat(index,dim./size(index))) = 0; 
r(isnan(r)) = MIN_READOUT;
r_th = r;
clear r
z( repmat(index,dim./size(index))) = 0;
z(isnan(z)) = MIN_READOUT;
z_th = z;
end