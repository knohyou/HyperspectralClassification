function [sup_image] = Superpixel_SLIC(Mice_Num, Slice1, nSuperpixel, Superpixel_Constraint, Results_Folder)
%cd('SLIC_mex')
%mex -setup  
%mex -O slicmex.c
[sup_image, numlabels] = slicmex(Slice1,nSuperpixel,Superpixel_Constraint);
sup_image = double(sup_image);
save(strcat(Results_Folder,'\superpixel_',num2str(Mice_Num),'.mat'),'sup_image')  
disp('Applied Superpixel Algorithm')
%cd ..
end
