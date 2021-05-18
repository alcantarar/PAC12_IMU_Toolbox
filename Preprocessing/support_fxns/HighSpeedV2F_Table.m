function [volts_data_array, transducer_force, summed_force, colnames, clipped_forces] = HighSpeedV2F_Table(volts_data, scale)
%HIGHSPEEDV2F_TABLE converts raw voltage output from CU's High Speed Treadmill to
%Newtons. Works for data collected before or after Treadmetrix changes
%made in Spring 2019 (see SCALE input).
%
%   Calibration Matrix values pulled from "Export Forces and COP High
%   Speed Treadmill.v3s" V3D Pipeline.
%
%   Parameters :
%   ----------
%   volts_data :    N x 12 table of voltage data from treadmill. Must have
%                   column headers in 'Fx1...4', Fy1...4','Fz1...4' format.
%   scale :         Scaling factor for Calibration Matrix. For data
%                   collected prior to changes made to Treadmetrix in Spring
%                   2019, use scale = 1. Changes affected the signal gain,
%                   requiring Calibration Matrix to be multiplied by 2
%                   (scale = 2).
%
%   Output :
%   ----------
%   {volts_data_array} :    nx12 matrix of volts data in {colnames} order
%   {transducer_force} :    nx12 matrix of newtons data in {colnames} order
%   {summed_force} :        nx3 matrix of summed forces (horiz,horiz,vert)
%   {colnames} :            Order of transducer signals (Fx1, Fx2, etc.)
%
%   Error :
%   ----------
%   Make sure input is just force data in table. Vicon sometimes stores marker
%   trajectories below the force data, but these need to be removed. Just
%   export forces only. If unsure, scroll to bottom of force data in excel
%   (Ctrl + down-arrow will jump to next empty cell) and check.
%
% Created on: Oct 2018
% Created by: Ryan Alcantara | ryan.alcantara@colorado.edu
%
% Last Modified on: June 2018
% Last Modified by: Ryan Alcantara

%if you know what's good for you, don't change this calibration matrix.
calmat = [...
    -36.5075 0 0 0 0 0 0 0 0 0 0 0;...
    0 -36.3925 0 0 0 0 0 0 0 0 0 0;...
    0 0 142.454 0 0 0 0 0 0 0 0 0;...
    0 0 0 36.4102 0 0 0 0 0 0 0 0;...
    0 0 0 0 36.2167 0 0 0 0 0 0 0;...
    0 0 0 0 0 143.057 0 0 0 0 0 0;...
    0 0 0 0 0 0 36.3198 0 0 0 0 0;...
    0 0 0 0 0 0 0 36.4503 0 0 0 0;...
    0 0 0 0 0 0 0 0 143.061 0 0 0;...
    0 0 0 0 0 0 0 0 0 -36.3428 0 0;...
    0 0 0 0 0 0 0 0 0 0 -36.4966 0;...
    0 0 0 0 0 0 0 0 0 0 0 143.414];
%apply scale to calmat
calmat = calmat*scale;
%sort table columns
ordered_cols = {'Fx1','Fy1','Fz1','Fx2','Fy2','Fz2','Fx3','Fy3','Fz3','Fx4','Fy4','Fz4'};
volts_data = volts_data(:,ordered_cols); %reorg columns
colnames = volts_data.Properties.VariableNames;
if sum(cellfun(@strcmp, volts_data.Properties.VariableNames,ordered_cols)) ~= 12
    error('table order column issue')
end
%convert to array because matlab tables suck
volts_data_array = table2array(volts_data);

%check to see if there's clipping from signal drift. Primarily affected data
%collections prior to 2019. Set up so that false negative rate is low, but
%can definitely get some false positives. 
if size(volts_data_array,2) == 12
    abs_volts = abs(volts_data_array);
    clip_stance = NaN(3000,size(abs_volts,2));
    for t = 1:size(abs_volts,2)
        try
            clip_idx = diff(diff(abs_volts(:,t)) ==0);
            start_clip = find(clip_idx == 1)+1;
            start_clip = start_clip(max(abs_volts(:,t)) - abs_volts(start_clip,t)  < 1); %only keep points within 1v of max
            end_clip = find(clip_idx == -1);
            end_clip = end_clip(max(abs_volts(:,t)) - abs_volts(end_clip,t)  < 1);
            
            end_clip = end_clip(end_clip > start_clip(1));
            start_clip = start_clip(1:length(end_clip));
            mid_clip = round(median([end_clip, start_clip],2)); % use this to ID steps where clipping present.
            
            %visualize
            if length(end_clip) > 1
                figure(t)
                hold on
                plot(volts_data_array(:,t))
                plot(start_clip, volts_data_array(start_clip,t),'go')
                plot(end_clip, volts_data_array(end_clip,t),'ro')
                %         plot(mid_clip, volts_data_array(mid_clip,t),'k*')
                hold off
            else
                break
            end

            warning([colnames{t} ' is saturated. Bad steps indices stored in `data.clipped_forces_ID`'])
            clip_stance(1:length(mid_clip),t) = mid_clip; %store frames where clipping occurs
        catch
            
        end
    end
    %pause to look at graphs if present.
    g = groot;
    if ~isempty(g.Children)
        reply = input('Continue with import? (y/n): ','s');
        if reply == 'y'
        close all;
        else 
            return
        end
    else
    end
    
    %combine all clip stances into x,y,z
    clip_x = rmmissing([clip_stance(:,2); clip_stance(:,5); clip_stance(:,8); clip_stance(:,11)]);
    clip_y = rmmissing([clip_stance(:,1); clip_stance(:,4); clip_stance(:,7); clip_stance(:,10)]);
    clip_z = rmmissing([clip_stance(:,3); clip_stance(:,6); clip_stance(:,9); clip_stance(:,12)]);
    clipped_forces = NaN(max([length(clip_x), length(clip_y), length(clip_z)]),3);
    clipped_forces(1:length(clip_x),1) = clip_x;
    clipped_forces(1:length(clip_y),2) = clip_y;
    clipped_forces(1:length(clip_z),3) = clip_z;
    
    %apply calibration matrix
    transducer_force = volts_data_array(:,:)*calmat; %12 force channels (xyz*4t transducers)
    %swap X & Y
    force_data = NaN(length(volts_data_array),3); %initialize
    force_data(:,1) = transducer_force(:,2) + transducer_force(:,5) + transducer_force(:,8) + transducer_force(:,11);
    force_data(:,2) = transducer_force(:,1) + transducer_force(:,4) + transducer_force(:,7) + transducer_force(:,10);
    force_data(:,3) = transducer_force(:,3) + transducer_force(:,6) + transducer_force(:,9) + transducer_force(:,12);
    summed_force = force_data;
else
    error('volts_data not 12 channels')
end

