function data = import_baseline_data(force_folder, imu_folder, school)
%IMPORT_BASELINE_DATA imports the force and IMU data for one baseline trial
%that occurred at Stanford, Oregon, or CU Boulder (treadmill schools) and
%stores variables in a matlab structure.
%
%   INPUTS:
%   force_folder:   String; folder containing baseline trial's force data.
%                   File format is determined by SCHOOL input. If more than
%                   one force file is present (static & dynamic), the
%                   larger file will be chosen. Passes folder name to
%                   IMPORTFORCES subfunction.
%   imu_folder:     String; folder containing baseline trial's IMU data
%                   files. Passes folder name to IMPORTIMUS subfunction.
%   school:         String determining which force data filetype is
%                   present and method of importing file in subfunctions. 
%                   Options are "Stanford", "Oregon", and "Colorado". 
%   
%   OUTPUTS:         
%   data:           MATLAB Structure containing raw force, time, and IMU
%                   (accelerometer, magnetometer, gyroscope) data as well 
%                   as information about school, treadmill manufacturer, &
%                   Fs. Note: there are multiple time vectors; 1 for the 
%                   treadmill and 1 for each sensor. 
%
%   EXAMPLE:
%   data = import_baseline_data('Sub01/Forces','Sub01/IMUs','Colorado')
%   >>  data = 
%       struct with fields:
%       force: [18000×3 double]
%        time: [18000×1 double]
%         IMU: [1×1 struct]
%  university: 'Colorado'
%          Fs: 1000
%
%   >>  data.IMU =
%       struct with fields:
%       Rshank: [1×1 struct]
%       Lshank: [1×1 struct]
%       Sacrum: [1×1 struct]
%           Fs: 500
%
%   >>  data.IMU.Rshank =
%       struct with fields:
%          a: [93000x3 double]
%          w: [93000x3 double]
%          m: [93000x3 double]
%       time: [93000x3 double]
%
%
% Created on: June 2019
% Created by: Ryan Alcantara | ryan.alcantara@colorado.edu
%

switch school
    case 'Stanford'
        force_file = dir([force_folder '/*.anc']);
        if size(force_file,1) <1
            error(['no *.anc files found in: ' force_folder])
        elseif size(force_file,1) >1
            warning(['more than one *.anc file found in: ' force_folder '. Picking larger file:'])
            force_file = force_file(find(max(force_file.bytes)));
        end
        
        disp(['Loading Forces: ' force_file.name])
        % Import Force Data
        data = importforces(force_folder, force_file.name, school);
        % Import IMU Data
        data = importIMUs(imu_folder, data,'local');
        % Add information
        data.university = school;
        data.treadmill = 'Bertec';
        data.Fs = 2000; %sampling freq
        data.IMU.Fs = 500; %sampling freq

    case 'Oregon'
        force_file = dir([force_folder '/*.forces']);
        if size(force_file,1) <1
            error(['no *.forces files found in: ' force_folder])
        elseif size(force_file,1) >1
            warning(['more than one *.forces file found in: ' force_folder '. Picking larger file:'])
            force_file = force_file(find(max(force_file.bytes)));
        end
        
        disp(['Loading Forces: ' force_file.name])
        % Import Force Data
        data = importforces(force_folder, force_file.name, school);
        % Import IMU Data
        data = importIMUs(imu_folder, data,'local', school);
        % Add information
        data.university = school;
        data.treadmill = 'Bertec';
        data.Fs = 1000;
        data.IMU.Fs = 500;
        
    case 'Colorado'
        force_file = dir([force_folder '/*.csv']);
        if size(force_file,1) <1
            error(['no *.csv files found in: ' force_folder])
        elseif size(force_file,1) >1
            warning(['more than one *.csv file found in: ' force_folder '. Picking larger file:'])
            force_file = force_file(find(max(force_file.bytes)));
        end
        
        disp(['Loading Forces: ' force_file.name])
        % Import Force Data
        data = importforces(force_folder, force_file.name, school);
        % Import IMU Data
        data = importIMUs(imu_folder, data,'local');
        % Add information
        data.university = school;
        data.treadmill = 'Treadmetrix';
        data.Fs = 1000;
        data.IMU.Fs = 500;
end

end

