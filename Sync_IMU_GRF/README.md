<p align="center">
  <img width="250"  src="APP_Support/small.gif">
</p>

# InSink
Just like Justin, JC, Chris, Joey, and Lance's dance moves, we want our IMU and GRF signals to be "NSYNC". :sweat_smile:
The InSink App temporally syncs multiple IMU sensors to each other and then syncs them to a vGRF signal. It syncs signals
via the cross-correlation of a given signal interval in the frequency domain. InSink was made by [Ryan Alcantara](https://twitter.com/Ryan_Alcantara_)
using MATLAB App Designer (2019a).

# How do I install the InSink App?
The InSink App has been compiled to run as its own standalone application, so you don't need MATLAB open or installed to
run InSink. 
## Windows Installation: 
1. Clone/Download the repository to your computer by navigating [here](https://github.com/alcantarar/PAC12_IMU_Toolbox) and clicking the green "Clone or Download" button.
2. Unzip the file, navigate to the `Sync_IMU_GRF/APP/InSink/for_redistribution` folder and run the installer: `MyAppInstaller_web.exe`. 
3. Follow the instructions for the installer. This can take a few minutes if MATLAB Runtime isn't already installed.
4. InSink will be installed in the location you selected in the installer. Press the Windows key and type 'InSink' to locate it.


# How do I use the InSink App?
Watch the [video tutorial](https://youtu.be/kXM43ulKuvA) for a walkthrough using the data in the [`Sample_Data`](Sample_Data) folder. The sample data 
is a *.mat file that has already been pre-processed via the `Baseline_Preprocessing.m` located at `PAC12_IMU_Toolbox/Preprocessing/`.

# What if I found a bug? :beetle:
Submit an issue or ask questions 
[here](https://github.com/alcantarar/PAC12_IMU_Toolbox/issues) and be sure to include enough information to reproduce the error.

