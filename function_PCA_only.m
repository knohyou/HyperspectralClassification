function [Reflectance_Cal_PCA_Image, latent] = function_PCA_only(Reflectance_Cal, w)


x_size = size(Reflectance_Cal,1);
y_size = size(Reflectance_Cal,2);

%% Apply PCA
% PCA is applied to the Reflectance Normalized Dataset
Reflectance_Cal_Vector = reshape(Reflectance_Cal,[x_size*y_size, length(w)]);
[coeff,score, latent] = pca(Reflectance_Cal_Vector);
Reflectance_Cal_PCA = Reflectance_Cal_Vector*coeff;
Reflectance_Cal_PCA_Image = reshape(Reflectance_Cal_PCA,[x_size,y_size,length(w)]);
end

