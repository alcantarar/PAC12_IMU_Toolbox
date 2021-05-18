# PAC12_IMU_Toolbox
Repository contains materials for use of IMeasureU inertial measurement units for biomechanics research. 
These materials were developed as a part of a research study funded by the PAC-12 Student Health and Well-being Grant 
Program and a collaboration between the University of Colorado, University of Oregon, Stanford University, and University
of Southern California. 

This repository contains code and materials generated during this collaboration and is maintained by Ryan Alcantara. 
Please open an issue if you have a particular inquiry or need help adapting this approach for your study. The following
publications have implemented aspects of this toolbox:

- ["Sacral acceleration can predict whole-body kinetics and stride kinematics across running speeds"](https://peerj.com/articles/11199/)
 by Alcantara et al. (2021)
- ["Low-pass filter cutoff frequency affects sacral-mounted inertial measurement unit estimations of peak vertical ground
reaction forces and contact time during treadmill running"](https://doi.org/10.1016/j.jbiomech.2021.110323) by Day et al. (2021)

# Order of Operations

## 1. Collecting IMU and GRF data
### Sensor Location
We used 3 IMUs to collect data on the lower legs and sacrum. IMeasureU provides velcro straps to adhere their device just
above the ankle. IMUs on the left/right shank were located laterally on the lower leg with the device's +y axis oriented
proximally and the +z axis oriented medially. Refer to `IMU_Blue_Thunder_Specifications.pdf` for more information about
the specifications. We developed a custom 3D-printed clip to adhere an IMU to the waistband of running shorts. 
Information about the IMU clip can be found in `Sacral_IMU_Clip/`. 

### IMU Collection Mode
We collected accelerometer, gyroscope, and magnetometer at 1000 Hz for all data collections. This was accomplished via
the "on board" collection mode, not the "streaming" mode.

### Temporal Synchronization
IMU and GRF data were collected simultaneously using different software. Additionally, pilot testing revealed discrepancies
in temporal synchronization between IMUs. We implemented a 2-step approach to synchronize 1) IMUs to each other, and 2) 
IMUs to the GRF data. We followed these steps for each data collection:

#### 1. Sync IMUs to each other
1. Start IMU data collection
1. Place all IMUs on swivel desk chair in identical orientation. *If you don't have a swivel desk chair, hold all IMUs in
your hand.*
1. Wait 5 seconds to provide a "quiet" period of data collection
1. Swivel chair back and forth 3-5 times while pressing down on IMUs to ensure they all rotate together on the chair. *If
you don't have a swivel desk chair, spin back and forth while holding the IMUs.* 
1. Wait 5 seconds to provide a "quiet" period of data collection

#### 2. Sync IMUs to GRF data
1. Place IMUs on participant
1. Start GRF data collection via motion capture software
1. Instruct participant to stand still on force-measuring treadmill for 5 seconds, perform countermovement jump in-place, 
and stand still for another 5 seconds
1. Start experimental trial(s)
1. End experimetnal trial(s)
1. Instruct participant to stand still on force-measuring treadmill for 5 seconds, perform countermovement jump in-place, 
and stand still for another 5 seconds
1. End GRF data collection via motion capture software
1. Remove IMUs from participant

#### 3. Sync IMUs to each other (again)
1. Place all IMUs on swivel desk chair in identical orientation
1. Wait 5 seconds to provide a "quiet" period of data collection.
1. Swivel chair back and forth 3-5 times while pressing down on IMUs to ensure they all rotate together on the chair
1. Wait 5 seconds to provide a "quiet" period of data collection
1. End IMU data collection

Later on, we'll use the IMU's angular velocity during the swivels to synchronize IMUs to each other and used the IMU's
vertical linear acceleration during the countermovement jump to synchronize IMUs to the GRF data. Synchronizing the IMUs
before and after GRF data collection allows us to account for any drift in the individual IMU clocks. It is important 
to note that this approach may generate large file sizes since IMU and GRF data are collected continuously for the entire
data collection session. You can modify this approach to fit your needs but ensure that there are opportunities to
synchronize IMUs to each other and to GRF data.

When downloading IMU data from the device, ensure that the data collection date and segment name is included in the 
filename. The scripts in this repository expect slight variations of the following naming conventions for IMU data:

- `Rshank_2020_10_26.csv`
- `Lshank_2020_10_26.csv`
- `Sacrum_2020_10_26.csv`

For a list of the acceptable variations for IMU file naming or if you aim to implement additional or different 
IMU locations, start by inspecting `Preprocessing/support_fxns/importIMUs.m`.

## 2. Organizing IMU and GRF files
Following data collection and data download from IMUs, organize your IMU and GRF data in the following way:
```
 SUBJECT_ID/
   - COLLECTION_1/
   - COLLECTION_2/
   - COLLECTION_3/
       - IMU_data/
           - Rshank_2020_10_26.csv
           - Lshank_2020_10_26.csv
           - Sacrum_2020_10_26.csv
       - GRF_data.csv
```
The `Baseline_Processing.m` script isn't very smart. It may get mixed up if there are additional CSV/ANC/FORCE files 
located in the directory structure above. Our study was longitudinal, so there were multiple collections for each 
subject ID. 

## 3. Processing IMU and GRF data
Next, we aim to combine IMU csv files and GRF ASCII file into single MATLAB structure. The scripts we used likely require
modification based on your lab's motion capture software and force-measuring equipment. View `Preprocessing/README.md` 
for information about the script to run and how to modify it for your particular use case. If you get stuck, open an issue
and ask for help!

## 4. Synchronizing IMU and GRF data
We developed a standalone MATLAB-based application for Windows that temporally synchronizes IMU and GRF data: InSink. 
View `InSink/README.md` for more information on how to use the application. If you run into bugs, open an issue! 


