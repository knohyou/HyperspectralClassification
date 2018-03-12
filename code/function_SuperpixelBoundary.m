Test = Superpixel_Cal_Matrix(:,:,1);
[xsize, ysize] = size(sup_cal_image);
figure; imagesc(Test)
Region = zeros([xsize, ysize]);
for i = 0:max(max( sup_cal_image))
        [indx] = find( sup_cal_image == i);
        Region(indx) = 1;
        [B,L]  = bwboundaries(Region);
hold on
for k = 1:length(B)
    boundary = B{k};
    plot(boundary(:,2), boundary(:,1), 'k', 'LineWidth', 1)
end
end