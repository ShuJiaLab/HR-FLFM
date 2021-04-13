# HR-FLFM Data Processing Program

This package is for data preprocessing and HR-FLFM 3D reconstruction. It is developed with Matlab 2020+.

> Note that this version is still a developing version with all the core functions mentioned in the [paper](https://doi.org/10.1364/OPTICA.419236) included, and in the future more improvements will be made to be more user-friendly. Some functions are still under testing and will be marked as [beta].

### Usage

* Use the “Open Directory” to point the program to a targeted folder.

#### BKGsub - Background Subtraction

This section contains two methods of background subtraction:

-  Background subtraction by offset
-  Background subtraction by rolling ball algorithm [**beta**]

This is mainly for thick samples which has more background caused by out-of-focus structures.

#### ACsN - Denoising Algorithm

This is developed by Biagio Mandracchia, the post doc in our lab ([More info about Biagio->](https://github.com/bmandracchia) / [More info about ACsN->](https://doi.org/10.1038/s41467-019-13841-8)) for camera noising denoising.

> Note this section will need parallel computing for computational acceleration.

#### TR & CONV - Image Trim and Conversion

* The image trim is pixel-based and contains two modes:
  * With Circle Masks - only count the three elemental images.
  * Without Circle Masks - like normal image cropping
* Use the “Combine FLFM PSF into MAT File” button to convert .tif-format PSFs into a single .mat file.
* Use the “Combine FLFM IMG to MAT File” button to convert .tif HR_FLFM raw image into .mat format.

> Note that both PSFs and the HR-FLFM raw image should be in .mat format to be correctly loaded into 3D reconstruction codes.

#### RECON - 3D Reconstruction

This section is for HR-FLFM 3D reconstruction.

- Use the “PSF File” button to specify the PSF path.

- Use the “FLFM File” button to specify the HR-FLFM raw image folder. If there are more than one images in the folder, the program will perform reconstructions for every image which has a .mat-format file sequentially.
- Set the Iteration Number
- Use the “Reconstruction File” button to specify the folder location for saving the reconstructed results.
- Click the “RL Deconvolution” button to start the reconstruction process. The status bar at the bottom will show the status and will turn green when the process is completed.

#### DISP - Image Display

[**beta**] *\* This section is still being developed.*
