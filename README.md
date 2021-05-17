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


## Running `Example_Code_PAC12.m`:
1. syncs IMUs together via `sync_IMUs.m` and saves file in `IMUsynced_data` folder
2. syncs IMUs to Treadmill via `sync_Forces.m` and saves file in `IMUsynced_data\FP_synced_data` folder
    
