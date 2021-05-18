function [sensors_found] = findsensors(loc,possible_sensors)
%FINDSENSORS Searches the fields of a MATLAB structure [loc] for matches
%with a cell array [possible_sensors], creating a cell array of matches: 
%[sensors_found]
%
% Created by Ryan Alcantara | ryan.alcantara@colorado.edu 
%
% Last Modified: 08/2019 by Ryan Alcantara
%
%   INPUTS:
%   loc:                MATLAB structure type, (e.g. data.IMU)
%   possible_sensors:   Cell array containing possible fields to look for
%                       in [loc]. Example: {'Sacrum', 'sacrum',
%                       'Rshank','Lshank'}
%   OUTPUTS:
%   sensors_found:      Cell array containing elements of [possible_sensors]
%                       found within the fields of [loc].
%

c = 1;
for i = 1:length(possible_sensors)
    if isfield(loc, possible_sensors{i})
        sensors_found(c) = cellstr(possible_sensors{i});
        c = c+1;
    end
end


