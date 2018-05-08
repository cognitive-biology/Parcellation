function ShowCorrelationMatrix( mu_z_clean, z_threshold )
mu_z_clean( abs( mu_z_clean ) <= z_threshold ) = z_threshold;

cmin = z_threshold;
cmax = 1;

cmap = MyJetColormap;

[n,m] = size( mu_z_clean );
mu_z_extended = zeros( n+1, m+1 );
mu_z_extended(1:n, 1:m) = mu_z_clean;

figure;
hold on;
h = imagesc( mu_z_extended );
colormap( cmap );
caxis([cmin cmax]);

hold off;
axis 'equal';
axis off
end

