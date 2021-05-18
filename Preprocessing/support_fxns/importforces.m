function [data] = importforces(force_folder, fname, school)
%IMPORTFORCES reads in force data files from a treadmill/force plate from 
%each school's force file format. Creates MATLAB structure (data) for storage.
%
%   INPUTS:
%   force_folder:   String; folder containing baseline trial's force data.
%                   File format is determined by SCHOOL input. 
%   fname:          String; name of force data file located in force_folder.
%   school:         String determining which force data filetype is
%                   present and method of importing file. Options are 
%                   "Stanford" (*.anc), "Oregon" (*.forces), or "Colorado"
%                   (*.csv). 
%   
%   OUTPUTS:         
%   data:           MATLAB Structure containing raw force and time data
%                   from the treadmill.
%
%   EXAMPLE:
%   data = importforces('Sub01/Forces','Sub01_XC18_Baseline_Force.csv','Colorado')
%   >>  data = 
%       struct with fields:
%       force: [18000×3 double]
%        time: [18000x1 double]
%
%
% Created on: June 2019
% Created by: Ryan Alcantara | ryan.alcantara@colorado.edu
%


% Determine where data was collected
switch school
    case 'Stanford' %Stanford University
        [data.force, data.time] = read_stanford_anc(force_folder, fname);
        data.colDate = input('collection date? (YYMMDD): ');
        
    case {'Oregon'} % University of Oregon
        grf = importdata(fullfile(force_folder,fname), '\t', 5); % opens in a structure
        data.force = grf.data(:,2:4) + grf.data(:,9:11); %sum force from both belts
        temp = char(grf.textdata(3,1)); % extract sampling frequency
        force_sampling_rate = str2double(temp(12:15));
        data.time = grf.data(:,1)/force_sampling_rate; % Create time vector
        data.colDate = input('collection date? (YYMMDD): ');

    case {'Colorado'} % University of Colorado
        fid=fopen(fullfile(force_folder,fname),'r');
        header1 = textscan(fid,'%s%s%s%s%s%s%s%s%s%s%s%s%s%s %*[^\n]',1,'Delimiter',',', 'HeaderLines',3); %channel names
        text_data = textscan(fid,'%f%f%f%f%f%f%f%f%f%f%f%f%f%f %*[^\n]','Delimiter',',', 'HeaderLines',2); %channel data
        fclose(fid);
        signal_names = vertcat(header1{3:end});
        sub_id = strsplit(force_folder, '\');
        readme_name = join({sub_id{end-1}, sub_id{end}, 'README.txt'}, '_');
        if any(cellfun(@isempty, signal_names)) %if missing transducer signal (occurred in Indoor 2018)
            fid2 = fopen(fullfile(force_folder, readme_name{1}), 'a');
            fprintf(fid2, ['\n' date ' : Force file missing transducer signal.']);
            fclose(fid2);
            error([fullfile(force_folder,fname) ' is missing a transducer signal column.'])
        end
        signal_data = horzcat(text_data{3:end});
        channels = array2table(signal_data, 'VariableNames',signal_names);
        data.colDate = input('collection date? (YYMMDD): ');
        %scale calibration matrix depending on if data collection was
        %after february 6, 2019. On this date the treadmetrix gain changed.
        if data.colDate <= 190206
            [~, ~, data.force, ~,data.clipped_forces_ID]= HighSpeedV2F_Table(channels,1);
        else
            [~, ~, data.force, ~,data.clipped_forces_ID]= HighSpeedV2F_Table(channels,2);
        end
        
        if sum(any(~isnan(data.clipped_forces_ID))) > 0
            axes_names = {'X axis','Y axis', 'Z axis'};
            clipped_axes = any(~isnan(data.clipped_forces_ID));
            fid3 = fopen(fullfile(force_folder, readme_name{1}), 'a');
            bad_axes = axes_names(clipped_axes);
            for a = 1:size(bad_axes,2)
                fprintf(fid3, ['\n' date ' : ' bad_axes{a} ' of GRF may have signal saturation. Check `data.clipped_forces_ID`.']);
            end
            fclose(fid3);
        else
            data = rmfield(data, 'clipped_forces_ID');
        end

            
        force_sampling_rate = 1000;
        data.time = linspace(0, length(data.force)/force_sampling_rate, length(data.force))';
end

end

