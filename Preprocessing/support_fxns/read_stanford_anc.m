function [GRFs, time] = read_stanford_anc(inpath, infile)
% This is reads in .anc files from Stanford and extracts the time and force
% vectors. Conversion to volts and calibration matrix values pulled from
% STANFORD_CONVERTGRFS function by Amy Silder (2005). Some unused variables
% were just carried over from that function for future functionality. This
% script is much faster than using READ_ANC & STANFORD_CONVERTGRFS.
%
%           FLIPS X & Y GRF AXES TO MATCH OREGON & CU BOULDER.
%
% Created on: June 2019
% Created by: Ryan Alcantara | ryan.alcantara@colorado.edu
%
% Last Modified on:
% Last Modified by:

fid=fopen(fullfile(inpath,infile),'r');

header1 = textscan(fid,'%s%s%s%s%s%f%s%f',1, 'HeaderLines',2); %duration and # of channels
header2 = textscan(fid,'%s%s%s%f',1); %sampling rate
header3 = textscan(fid,'%s%s%s%s%s%s%s%s%s%s%s%s%s %*[^\n]', 1); %time + channel names
header4 = textscan(fid,'%s%f%f%f%f%f%f%f%f%f%f%f%f %*[^\n]', 1, 'HeaderLines',2);
text_data = textscan(fid,'%f%f%f%f%f%f%f%f%f%f%f%f%f %*[^\n]','HeaderLines',1); %only read in time and grf channels (first 13 columns)

fclose(fid);
duration = header1{6};
num_channels = header1{8};
samp_rate = header2{4};
channel_names = vertcat(header3{:});
channel_names{1} = 'Time';
range = horzcat(header4{2:size(header4,2)});
time = text_data{1};
data = horzcat(text_data{2:size(text_data,2)}); %remove EMG, keep forces.

% 16-bit system 2^16 = 65536
% range is given in milivolts, so multiply by 0.001 to make volts
dataV=(ones(size(data,1),1)*range(1:size(data,2))*2).*(data/65536)*0.001; % Convert all data into volts

forces = NaN(size(dataV));
% Current treadmill calibration matrix, for both belts
CalMatrix =[500,0,0,0,0,0;0,500,0,0,0,0;0,0,1000,0,0,0;0,0,0,800,0,0;0,0,0,0,250,0;0,0,0,0,0,400];
forces(:,1:6)=dataV(:,1:6)*CalMatrix;
forces(:,7:12)=dataV(:,7:12)*CalMatrix;

GRFs=forces(:,1:3)+forces(:,7:9);

%% Flip X & Y to match other schools' Coordinate Systems
GRFs = GRFs.*[-1, -1, 1];
% +X is runner's right
% +Y is posterior (+ = propulsive, - = braking)
% +Z is inferiror (+ = pushing down on the treadmill)

end
