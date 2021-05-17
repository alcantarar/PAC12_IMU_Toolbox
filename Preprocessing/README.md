# Preprocessing 
This script reads in IMU and GRF data to combine it into a single Matlab structure. No filtering or trimming of files 
is performed. It provides a uniform file structure for future processing and analysis steps following data collection
at multiple universities. 

Each university had a preferred method of exporting GRF data from their motion capture software, and this script
handles these differences. For example, Colorado uses Vicon Nexus and a Treadmetrix treadmill that exports GRF data
as a *.CSV file while Oregon uses Motion Analysis Cortex and a Bertec treadmill that exports GRF data as an *.ANC file.

### Each data collection session will have one matlab structure called `data` with the following hierarchy:
- `colDate` (double; format: YYMMDD; date of data collection)
- ``force`` (nx3; **raw & untrimmed** forces (N) from treadmill [X,Y,Z]:  
           +X = runner’s right,  
           +Y = posterior (propulsive),  
           +Z = downward (pushing down on treadmill))
- ``time`` (nx1; seconds from treadmill)
- ``IMU``
- ``Rshank``/``Lshank``/``Sacrum``
  - `a` (nx3; [link to XYZ orientation](https://imeasureu.com/wp-content/uploads/2017/11/SensorSpecSheet.pdf); Accelerometer (g) from IMU)
  - `w` (nx3; [link to XYZ orientation](https://imeasureu.com/wp-content/uploads/2017/11/SensorSpecSheet.pdf); Gyroscope (deg/s) from IMU)
  - `m` (nx3; [link to XYZ orientation](https://imeasureu.com/wp-content/uploads/2017/11/SensorSpecSheet.pdf); Magnetometer (uT) from IMU)
  - `time` (nx1; seconds; sensor-specific)
- `Fs` (double; IMU sampling frequency in Hz - assumed 500Hz per protocol)
- `university` (string; `'Colorado'`, `'Oregon'`, or `'Stanford'`)
- `treadmill` (string; `'Treadmetrix'` or `'Bertec'` depending on `university`)
- `Fs` (double; Treadmill sampling frequency in Hz - assumed 1000Hz for Oregon/Colorado, 2000Hz for Stanford)
- `subID` (string; extracted from folder name in `Baseline_Preprocessing.m`)