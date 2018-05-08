function [IM_multivariate,IM_bivariate] = MutualInformation(X)

X = nearestSPD(X);
G = chol(X);
IM_multivariate = -sum(log2(diag(G)));
%% sum mutual information from all pairs
P = X-tril(X);
Ptr = P(P~= 0);
IM_bivariate = -sum(log2(1-Ptr.*Ptr))/8; % why 8?!

end