# PAC12_IMU_Toolbox
Repository contains materials for use of IMeasureU inertial measurement units for biomechanics research. 
These materials were developed as a part of a research study funded by the PAC-12 Student Health and Well-being Grant Program.

# Order of Operations

## Collecting IMU and GRF data
- Tips for ensuring that IMU and GRF are temporally synchronized
- File naming convention

## Organizing IMU and GRF files
- Example file structure

## Running `Baseline_Preprocessing.m`
- Combines IMU csv files and GRF ASCII file into single MATLAB structure. Likely requires modification based on your
lab's motion capture software and force-measuring equipment. Inspect `Preprocessing/support_fxns/import_baseline_data.m`
and `Preprocessing/support_fxns/importforces.m` for examples on how to import GRF data that is in different formats. 

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

## Running `Example_Code_PAC12.m`:
1. syncs IMUs together via `sync_IMUs.m` and saves file in `IMUsynced_data` folder
2. syncs IMUs to Treadmill via `sync_Forces.m` and saves file in `IMUsynced_data\FP_synced_data` folder
    
