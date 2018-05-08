function plotContour2(label, bintype, pairtype, x_bin, y_bin, D_xy)

hold on;
contour( x_bin, y_bin, D_xy', 'LineWidth', 1 );
colormap('jet');


axis 'square';
xlabel('SNR_t', 'FontSize', 12);
ylabel('\sigma_t', 'FontSize', 12);
xlim([0 500]);
ylim([0 200]);
set( gca, 'XTick', [0 100 200 300 400], 'YTick', [0 50 100 150], 'FontSize', 9 );
title(label);

return;