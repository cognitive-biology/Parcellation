function plotContour3(label, bintype, pairtype, x_bin, y_bin, D_xy, x_med, y_med, clr)
% what does it do?
%
% PLOTCONTOUR3(LABEL,BINTYPE,PAIRTYPE,X_BIN,Y_BIN,D_XY,X_MED,Y_MED,CLR)

f = figure;

vdensity = [0.5 1.0 1.5 2.0 2.5 3.0];

vlabel = [1.0 2.0 3.0];

hold on;

[cs,h] = contour( x_bin, y_bin, D_xy', vdensity, 'Color', clr, 'LineWidth', 2 );
colormap('jet'); caxis([0 3.5]);
clabel(cs, h, vlabel, 'FontSize', 18, 'Color', clr );

colorbar;

plot( x_med + 0.05*[-1 1], y_med + [0 0], 'Color', clr, 'LineWidth', 2 );
plot( x_med + [0 0], y_med + 0.025*[-1 1], 'Color', clr, 'LineWidth', 2 );
hold off;

axis 'square';
xlabel('CH', 'FontSize', 20);
ylabel('SC', 'FontSize', 20);
xlim([0.0 1.6]);
ylim([-0.15 0.8]);
set( gca, 'XTick', [0 0.5 1.0 1.5], 'YTick', [ 0.0 0.25 0.5 0.75], 'FontSize', 20 );
title([label '-' pairtype]);

return;