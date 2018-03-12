function  [Feature, Group, x_size_DS, y_size_DS, z_size_DS] = function_wo_superpixel(Reflectance_Cal_PCA_Image, Truth, Num_PCA, Downsample)

x_size = size(Reflectance_Cal_PCA_Image,1);
y_size = size(Reflectance_Cal_PCA_Image,2);
z_size = size(Reflectance_Cal_PCA_Image,3);

Reflectance_Cal_PCA_Image_Selected = Reflectance_Cal_PCA_Image(:,:,1:z_size);

Reflectance_Cal_PCA_Image_Selected_DS = Reflectance_Cal_PCA_Image_Selected(1:Downsample:end,1:Downsample:end,:);
Truth_DS = Truth(1:Downsample:end,1:Downsample:end);

x_size_DS = size(Reflectance_Cal_PCA_Image_Selected_DS, 1);
y_size_DS = size(Reflectance_Cal_PCA_Image_Selected_DS, 2);
z_size_DS = size(Reflectance_Cal_PCA_Image_Selected_DS, 3);

Feature = reshape(Reflectance_Cal_PCA_Image_Selected_DS, x_size_DS*y_size_DS,z_size);
Group = Truth_DS(:); 


end
