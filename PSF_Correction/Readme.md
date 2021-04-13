# PSF Correction/Calibration Manual

This is a program for generating hybrid PSF.

Before you run the process, please <ins>get the experimental PSFs and Simulated PSFs ready</ins>. 

> **Note 1** The simulated PSFs should be in **.mat** format and should be stored in a folder layer by layer separately. The experimental PSF should be in **.tif** format and should be stored in a folder layer by layer separately as well.

> **Note 2** The filename should be in a format of \<Latin letters\>+\<arabic numbders\>+\<suffix\>. The <arabic numbers> should be centered at <ins>50000</ins> (this matches the data acquired by MCL objective lens positioner).

### Procedure

* Set up simulated PSF folder and experimental PSF folder. If the files are correctly recognized, you can see “50000” shown in the “Sim-Exp Frame No” label, two previews shown in the figure boxes and you can preview other images using “backward” and “forward” buttons.
* Use the two “Get 3 ROIs” to determine the positions of the three PSF points for both simulated and experimental PSFs.
* Use the “Show ROIs” button to see the selected ROIs.
* Use “Get Aligning Displacement” button for the first displacement estimation.
* Then use “Manual Aligning” to check the aligning status and adjust the PSFs manually. The “Decrease dX/dY” and “Increase dX/dY” buttons to make the adjustment. The selection radio buttons switch and determine which PSF spot is functioned. The table on the right side shows the displacement values. In this step, try to set the displacements on other layers as the layer at 50000. This ensures the continuing lateral displacement of the three PSF spots along the axial direction.
* Use “Export Vars” to export and save the “Offset” into .mat format.
* Use “Load Offset” to load the saved offset values.
* Start rough aligning first. The status will show the process.
* Then setup and the “Fine Tune Resizing scale” to 10.
* Use the “Fine tune” to check if the fine displacement.
* Start fine aligning. The status will show the process.

* Try to stack the calibrated hybrid PSFs into a single .mat file for further reconstruction.
