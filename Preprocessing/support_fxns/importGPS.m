function [outputArg1,outputArg2] = importGPS(inputArg1,inputArg2)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%         Structure called GPS with the following fields:
%          - .time
%          - .dist (meters)
%          - .HR (bpm - missing data is 999)
%          - .altitude (m - normalized to starting altitude)
%          - .minpermile (pace)
%          - .mps (speed m/s)
%          - .gradient (% - estimated from mps and altitude)
%          - .UTM (converted from longitude and latitude. normalized to starting location)

 % ADD GPS LATER
% button=questdlg('Did you collect GPS data?','GPS watch data?','Yes!','No  ','Yes!');
% reset=1;
% if button=='Yes!'
%     [GPS] = SummarizeGPS;
%     reset=1;
% end
end

