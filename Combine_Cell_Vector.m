function [supervector] = Combine_Cell_Vector(Cell)
supervector = [];
for i = 1:length(Cell)
    supervector = [supervector; Cell{i}];
end
end
