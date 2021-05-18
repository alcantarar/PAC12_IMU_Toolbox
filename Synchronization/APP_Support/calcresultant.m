function [resultant] = calcresultant(components)
%CALCRESULTANT performs sqrt(x^2+y^2+z^2) on nx3 array [components].
%
%   INPUT
%   components: nx3 array containing x,y,z components
%
%   OUTPUT
%   resultant:  sqrt(x^2+y^2+z^2)
%
resultant = sqrt(components(:,1).^2 + components(:,2).^2 + components(:,3).^2);

end

