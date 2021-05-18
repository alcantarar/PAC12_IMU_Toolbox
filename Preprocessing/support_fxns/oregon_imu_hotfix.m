good_file = csvread(fullfile(imu_folder, 'Lshank.csv'),1,0);
len = length(good_file);
%%
fid=fopen(fullfile(imu_folder,'Rshank_bad.csv'),'r');

data = textscan(fid,'%f,%f,%f,%f,%f,%f,%f,%f,%f,%f', 'HeaderLines',1); %furation and # of channels

if any(abs(diff(cellfun(@numel, data)))) %see if number of elements in each column are different (indicating incomplete row).
    min_len = min(cellfun(@numel, data));
    tf = cellfun(@numel, data) == min_len;
    for i = 1:length(data)
        if tf(i) == 1 %too short, add NaN in there, will fix later
            data{i} = [data{i};NaN];
        else
        end
        data{i}(end) = NaN;
    end
end
%ok took care of incomplete row, now need to keep reading document

data2 = textscan(fid,'%f,%f,%f,%f,%f,%f,%f,%f,%f,%f', 'HeaderLines',2); %
if length(data{1}) + length(data2{1}) < 0.9*len
    data3 = textscan(fid,'%f,%f,%f,%f,%f,%f,%f,%f,%f,%f', 'HeaderLines',0); %
end

fclose(fid);

for i = 1:10
    newdata{i} = [data{i};data2{i};data3{i}];
    newdata{i} = fillmissing(newdata{i}, 'linear');
end

newdata = cell2mat(newdata);
