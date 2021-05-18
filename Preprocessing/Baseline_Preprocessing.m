%% Baseline Trial Processing Code
clearvars; close all;
% Set path (you'll need to replace w/ your directory containing code)
addpath('support_fxns')
% USER INPUT: Subject folder
% save_loc = uigetdir('Select Subject Folder');
save_loc = '..\Example_Data';
%
% Expects following directory format for IMU/GRF data. Any other files will
% produce inconsistent results:
%
% SUBJECT_ID/
%   - COLLECTION_1/
%   - COLLECTION_2/
%   - COLLECTION_3/
%       - IMU_data/
%           - Rshank.csv
%           - Lshank.csv
%           - Sacrum.csv
%       - GRF.csv
%
%
% Check ImportIMUs() for list of acceptable IMU filenames.
%

%% Import Forces
TXT{1,1} = save_loc; %where GRF force data is located
id = strsplit(save_loc, '\');
TXT{1,2} = id{end}; %sub identifier number

% get all data collection folders
sub_dir = dir(save_loc);
is_dir_flag = [sub_dir.isdir];
sub_dir = sub_dir(is_dir_flag);
sub_dir = sub_dir(3:end);  % remove '.' directories

collections = {sub_dir.name};

for i = 1:size(collections,2)
    force_folder = fullfile(TXT{1,1}, collections{i});
    imu_folder = dir(force_folder);
    is_dir_flag = [imu_folder.isdir];
    imu_folder = imu_folder(is_dir_flag);
    imu_folder = imu_folder(3:end);
    %     imu_folder = uigetdir(force_folder, 'Select IMU folder');
    imu_folder = fullfile(force_folder, imu_folder.name);
    % display IMU filename for collection date info:
    imu_files = dir(imu_folder);
    disp(' ')
    disp(imu_files(3).name)
    
    % Can rework this depending on which format of GRF data you use. Colorado
    % uses a treadmetrix treadmill and exports a CSV through Vicon Nexus,
    % Stanford uses a Bertec and exports an ANC file through Cortex, and Oregon
    % uses a Bertec and exports a FORCE file through Cortex:
    if contains(collections{i}, 'Colorado')
        data = import_baseline_data(force_folder, imu_folder, 'Colorado'); %'Stanford', 'Oregon', or 'Colorado'
    elseif contains(collections{i}, 'Oregon')
        data = import_baseline_data(force_folder, imu_folder, 'Oregon'); %'Stanford', 'Oregon', or 'Colorado'
    elseif contains(collections{i}, 'Stanford')
        data = import_baseline_data(force_folder, imu_folder, 'Stanford'); %'Stanford', 'Oregon', or 'Colorado'
    else
        school = input('which school was this data collected at? Colorado, Stanford, or Oregon?', 's');
        data = import_baseline_data(force_folder, imu_folder, school); %'Stanford', 'Oregon', or 'Colorado'
    end
    
    
    data.subID = TXT{1,2};
    % save file
    savename = ['Baseline_' num2str(data.colDate) '_' num2str(data.subID)];
    save(fullfile(force_folder,savename), 'data');
    disp([fullfile(force_folder,savename) '.mat'])
end

%% Help Pages:
% help import_baseline_data
% help importforces
% help importIMUs
