function [trimmed_trial,start_frame,end_frame] = TrimTrial(trial_data,time)
%TrimTrial trims trials based on user input from plots. 
%Select idetifiable peak (hop/1st swivel) at the beginning and end of the trial. 
%Then TrimTrial will cut the trial .5s beyond the peak. 

%   Input:  1D signal and time vector. 
%   Output: 1D trimmed trial, and start/end index
%   Ryan Alcantara | ryan.alcantara@colorado.edu

figure('Position',[250 250 1200 600])
plot(time,trial_data)
title({'select first peak of hop or swivel at beginning of trial'}, 'Fontsize', 14)
% pause
[trial_lim,~] = ginput(1);
% close
Fs = round(1/mean(diff(time)));
trial = time > trial_lim & time < trial_lim + 1/Fs; %find index of frame

t_start = find(time == time(trial)) - round(Fs/2); %area before peak select (-.5s)
t_end = find(time == time(trial)) + round(Fs/2); %area after peak select (+.5s)
if t_start < 1
    t_start = 1;
end
if t_end > length(trial)
    t_end = length(trial);
end
[~,index] = max(trial_data(t_start:t_end));
start_frame = index + t_start - round(Fs)*2; %get peak in terms of whole trial (- 2s)

%now get end
% figure('units','normalized','outerposition',[0 0 1 1])
% plot(time,trial_data)
reset(gca)
title({'select last peak of hop or swivel at end of trial'}, 'Fontsize', 14)
% pause
[trial_lim,~] = ginput(1);
close
Fs = round(1/mean(diff(time))); 
trial = time > trial_lim & time < trial_lim + 1/Fs;

t_start = find(time == time(trial)) - round(Fs/2);
t_end = find(time == time(trial)) + round(Fs/2);
[~,index] = max(trial_data(t_start:t_end));
end_frame = index + t_start + round(Fs)*2; %get peak in terms of whole trial (+ 2s)


if start_frame < 1
    start_frame = 1;
end
if end_frame > length(trial_data)
    end_frame = length(trial_data);
end

%get even number of frames
if mod(length(trial_data(start_frame:end_frame)),2) == 1
    end_frame = end_frame -1; 
end

trimmed_trial = trial_data(start_frame:end_frame);

end

