function [r_th,z_th,index] = threshold(r,z,th)
% gets the correlations and z-scores matrix and applies the threshold on
% them
%
% [R_TH,Z_TH,INDEX] = THRESHOLD(RHO,Z,TH) gets the correlation and z-score 
%matrix  R and Z and applies the threshold TH on them. Finally, the thresholded
% correlation and z-score R_TH and Z_TH are generated and the indices of 
% insignificant arrays INDEX are given as output.


MIN_READOUT = realmin; % Smallest positive number (to be assigned for INF zscores)


z(isinf(z)) = NaN;
dim = size(z,1);
tmp = reshape(z,dim,dim,size(z,2)/dim);
mu = abs(nanmean(tmp,3));
sigma = nanstd(tmp,1,3);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
big_vec = z(:);
mu = zeros(1,dim*dim);
sigma = zeros(1,dim*dim);
for jnd = 1:dim*dim
    mu(jnd) = abs(nanmean(big_vec(jnd:(dim*dim):end))); 
    sigma(jnd) = nanstd(big_vec(jnd:(dim*dim):end));
end
mu = reshape(mu,dim,dim); % zscore
sigma = reshape(sigma,dim,dim);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mu(isnan(mu)) = MIN_READOUT;
sigma(isnan(sigma)) = MIN_READOUT;
cv = sigma/mu;
index = or(mu <= th, cv>=1);
clear sigma mu cv
z( repmat(index,size(z)./size(index))) = 0;
r(repmat(index,size(z)./size(index))) = 0;
r_th = r;
z_th = z;

end