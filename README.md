# MD758 Parcellation & Tools for Functional Sub-Parcellation

**MD758 Parcellation** is a comparatively fine parcellation of human cortex in Montreal MNI152 standard space.  It parcellates human cortex and subcortical gray nuclei into 758 clusters averaging 1.7 cm<sup>3</sup> gray matter volume.  MD758 builds on and refines the anatomical AAL parcellation (Tzourio-Mazoyer et al., 2002) with 90 regions averaging 14 cm<sup>3</sup> gray matter volume.  To subdivide each anatomical region, MD758 relies exclusively on functional correlations within this region, as recorded in eight resting observers (Dornas & Braun, 2018).  No spatial criteria are used.

MD758 reveals highly detailed correlational structure -- approximately 5 x 10<sup>4</sup> cluster-by-cluster correlations are consistently significant over the entire brain -- under various steady-state conditions (resting, continuous stimulation, sustained attention, etc).  Thus it reveals how the global correlational structure of the human brain is altered by different cognitive steady-states.

For the original group of observers, the observed correlation strength per cluster pair is quite high, comparable to that obtained with state-of-the-art, multi-modal parcellations (Craddock et al., 2012; Glasser et al., 2016).

For other observer groups, 'cluster quality' (Arslan et al., 2017) of MD758 is reduced, but still superior to that of a spatial parcellation with the same resolution (S758 parcellation).

Functional correlation and anatomical connectivity matrices of MD758 clusters, as observed by Dornas & Braun (2018), are supplied for purposes of comparision.  Anatomical connectivity was estimated with diffusion-weighted imaging and fibre tracking.


**S758 Parcellation** refines the anatomical AAL parcellation (Tzourio-Mazoyer et al., 2002) into 758 smaller clusters, purely on the basis of spatial proximity (Dornas & Braun, 2018). No functional criteria are used.

It provides a baseline for parcellation quality and serves a control ('null model', Gordon et al., 2016).

The functional correlation and anatomical connectivity matrices of S758 clusters are supplied as well.


**Functional sub-parcellation toolbox** provides a set of [MATLAB](https://mathworks.com/products/matlab) routines to refine a given coarse parcellation of the human brain into a finer parcellation based on resting-state functional imaging data.  MD758 was computed with these routines.

The method relies on temporal correlations between individual brain voxels, which are often highly signficant within functionally homogeneous brain regions. Perhaps surprisingly, these voxel-by-voxel correlations are often consistent between observers. 

The method can be used to 'personalize' a functional parcellation for a given observer or observer group.  It can be used for the whole brain or for selected brain regions of particular interest.

We do NOT expect this method to be suitable for sub-dividing large, functionally heterogeneous brain volumes (such as an entire lobe, or an entire hemisphere).   

Functional sub-parcellation is based on functional MRI data acquired from resting observers (eyes open or closed). Parcellation quality increases with the quality and amount of functional imaging data. 

Dornas & Braun (2018) used 4800 imaging volumes (TR) with an average temporal signal-to-noise ratio (tSNR) of approximately 240 (mean / standard devation of the signal time-courses of an individual voxel).  The standard deviation of the tSNR was approximately 30 over voxels and approximately 90 over observers. 

**Quality assessment tools** 

Several routines are provided for assessing data quality at different stages of processing, for example the quality of raw functional imaging data, preprocessed data, the strength of functional correlations between voxels, and the quality of a resultig parcellation (Gordon et al., 2016; Arslan et al., 2017).  

These routines should be helpful for 'debugging' imaging protocol and processing pipeline.

## Contents ##

1. [Citing MD758](#citing-md758-or-functional-sub-parcellation)
2. [Requirements](#requirements)
3. [How to use](#how-to-use)
4. [Analyzing correlational structure](#analyzing-correlational-structure)
5. [Functional sub-parcellation](#functional-sub-parcellation)
6. [Pipeline](#pipeline)
7. [Core routines](#core-routines)

## Citing MD758 or functional sub-parcelllation ##

The functional parcellation MD758, a spatial parcellation called S758, tools for performing a functional sub-parcellation on the basis of resting-state functional imaging data, anatomical connecticity based on fibre-tracking, and various measures for assessing parcellation quality are described in:

Dornas, J. V., & Braun, J. (2018). Finer parcellation reveals detailed correlational structure of resting-state fMRI signals. Journal of neuroscience methods, 294, 15-33. <https://doi.org/10.1016/j.jneumeth.2017.10.020>

## Requirements ##

In order to use the provided parcellation information, tools, and example code, you will need:

- MATLAB 
- [Statistics and Machine Learning Toolbox](https://www.mathworks.com/products/statistics.html)
- nifti1 matlab toolbox (download [here](https://nifti.nimh.nih.gov/nifti-1/) or [here](https://sourceforge.net/projects/niftilib/files/niftimatlib/niftimatlib-1.0/niftimatlib-1.0.tar.gz/download) )

## How to use ##

Download or clone MD758 functional sub-parcellation [here](https://github.com/cognitive-biology/Parcellation.git). Don't forget to [set the path](https://mathworks.com/help/matlab/matlab_env/add-remove-or-reorder-folders-on-the-search-path.html) of the toolbox in your matlab directory.

Before starting, you may want to read the [core routines](#core_routines) and to run the [demo](https://github.com/cognitive-biology/Parcellation/blob/master/examples/demo.m) file created, which illustrates the use of this toolbox.

**WARNING:** Due to large size of fMRI data, functional parcellation is memory consuming.  Make sure to save any unsaved processes before starting this program. (Do you mean: stop all other processes?)

## Analysis of functional correlations with MD758 or S758 ##
To analyze the correlational structure of your own functional imaging data with the MD758 parcellation, you will need your pre-processed imaging data in MNI1512 space and the *nifti* files defining this parcellation (which are provided here).

The result of the analysis will be the correlational structure of your imaging data at the resolution of the MD758 parcellation.

<figure>
  <img src="https://github.com/cognitive-biology/Parcellation/blob/master/html/FC_matrix_MD758.png" alt="MD758" width="1000">
  <figcaption>Fig 1. - Correlation matrix at the resolution of MD758.</figcaption>
</figure>


For purposes of comparison, you can additionally establish the correlational structure of your data with a spatial parcellation S758.  

<figure>
  <img src="https://github.com/cognitive-biology/Parcellation/blob/master/html/FC_matrix_S758.png" alt="S758" width="1000">
  <figcaption>Fig 2. - Correlation matrix at the resolution of S758.</figcaption>
</figure>
 
The *nifti* files defining this alternative parcellation are provided as well. In addition, optionally, a quantitative assessment of parcellation quality and correlational structure has been also provided.

## Functional sub-parcellation ##

In order to perform a functional sub-parcellation, you will need functional scans from resting observers, as well as a coarse atlas defining your anatomical regions of interest (for example, anatomical regions of the AAL parcellation).

The result will be your new parcellation (i.e., a *nifti* file dividing brain voxels into the new parcels) and, optionally, a quantitative assessement of parcellation quality and correlational structrure (e.g., cluster quality, mutual information, correlation matrix).

The various steps of this process are schematically illustrated here:

<figure>
  <img src="https://github.com/cognitive-biology/Parcellation/blob/master/html/pipeline.png" alt="pipeline" width="1000">
  <figcaption>Fig 3. - General pipeline of functional sub-parcellation.</figcaption>
</figure>


### Pipeline ###

Here we assume that your fMRI images have been preprocessed, i.e., field-map and head-motion corrected, temporally filtered, wavelet filtered, regressed, and finally warped and coregistered with your preferred standard space (e.g., MNI152 space).  It is important to use only minimal smoothing (e.g., only non-istotropic filtereing with 2mm), such as to preserve the signal time-course of individual voxels.  See Dornas & Braun (2018) for details.

Preprocessed images should be in *nifti* format, and contain the signal time-courses recorded for each voxels in your preferred standard space.  The number of time samples corresponds to the number volumes or TR recorded during each scan (e.g., N\_TR = 167), and the number of voxels depends on your standard space (e.g., N\_vox = 160000 for MNI152). In order to confirm that the images have the quality needed to use the finer functional parcellation, signal to noise ration for each voxel should be calculated.

<figure>
  <img src="https://github.com/cognitive-biology/Parcellation/blob/master/html/tsnr.png" alt="signal to noise" width="400">
  <figcaption>Fig 4. - Example of signal to noise ratio for an image in MNI152 space, parcellated using AAL90.</figcaption>
</figure>

1. **Map to atlas:** 

	Your chosen atlas defines the coarse brain regions that you wish to subdivide on the basis of functional correlations.  Naturally, this atlas must be provided in your chosen standard space.  The atlas should include a *nifti* file with voxel information (ID, coordinate and value) and *.mat* file with region information.  The latter contains a structure array named as **ROI** of size 1xN_ROI, where N_ROI is the number of regions.   Every member of the array has fields <mark>ROI.ID</mark> (value of the voxels used in *nifti* file), <mark>ROI.Nom</mark> (region abbreviation), and <mark>ROI.Nom\_L</mark> (region name).
	
	As an example, check [ROI\_MNI\_MD758\_List.mat](https://github.com/cognitive-biology/Parcellation/tree/master/atlas/MD758) or the *ROI\_MNI\_V5\_List.mat* of the [AAL parcellation](http://www.gin.cnrs.fr/en/tools/aal-aal2/).
	
	```
	ROI = 

  		1×90 struct array with fields:

    		ID
    		Nom_C
    		Nom_L
	``` 
	Given an atlas in this format, you can map images with the [img2atlas](#img2atlas) function. The output of this function is a *.mat* file containing a cell array **out\_data** with (1+N\_ROI) rows and 4 columns, with each row corresponding to a region in the atlas.  Note that the first row is special, as it comprises any and all voxels of the standard space that could not be assigned to any region.  The subsequent rows represent the regions in the order specified by the *ROI_list.mat* file. 
	
	The columns of the **out_data** array represent, in order, region number, region name, IDs of all voxels in the region, and signal time-courses of all voxels in the region.  For structural scans, 'time-courses' comprise only a single value.  For functional scans, time-courses comprise N_TR values. For example, in the [demo](https://github.com/cognitive-biology/Parcellation/blob/master/examples/demo.m) you will get the following data:
	
	```
	out_data =

  		3×4 cell array

    		{[0]}    {0×0 char   }    {25675×1 double}    {167×25675 double}
    		{[1]}    {'Angular_L'}    { 1173×1 double}    {167×1173  double}
    		{[2]}    {'Angular_R'}    { 1752×1 double}    {167×1752  double}
	``` 
	If you have mapped multiple scans/images to the atlas, you must combine all **out_data** cell arrays in a structure array with an **out_data** field.  The size of the structure array will be 1 x N_image, where N\_image is the number of images:

	```
	images = 

	  1×2 struct array with fields:

   		 out_data

	``` 
	
2. **Correlation profile of voxels:**
	
	After all images have been mapped to atlas in the manner described above, you can use the   [local_corr](#local_corr) function to compute the 'local correlation profile' for all voxels in one particular region of your atlas. For this purpose, you have to include all the images that have been mapped to the original parcellation, in a single structure array variable with the field <mark>out\_data</mark>. Then, you will have to specify the region number and the range of time-points (TR) to be used (e.g., in case you wish to discard some TR). The 'local correlation profile' of a voxel describes the correlation between the signal time-course of this voxel and the signal-time courses of all other voxels in the same region, separately for each image (scan) included in the input file.  Specifically, each pair-wise correlation is described in terms of correlation coefficient r, probability of significance p, and Fisher transformed value z.  The outputs are provided in the form of cell arrays with two dimensions: 1xN\_images, where inside each array is a square matrix of size N\_voxels x N\_voxels, i.e. correlation matrix of the selected region and the selected run.
	
 The ouput is 3 **.mat** files corresponding to correlation *rho*, Fisher transform value *zscore* and the probability of significance *pval*.
 
<figure>
  <img src="https://github.com/cognitive-biology/Parcellation/blob/master/html/corr_prof.png" alt="correlation profile" width="1000">
  <figcaption>Fig 5. - correlation profile of a voxel over 2 runs.</figcaption>
</figure>

3. **Consistently significant correlations:**

	Once the local correlation profiles of the voxels in a region have been calculated, you may choose to retain only consistently significant correlations for purposes of clustering.  To this end, you can apply a 'consistent significance' threshold by using the [threshold](#threshold) function.  Before doing so, you first need to convert cell arrays into ordinary arrays with the `cell2mat` function. The matrix dimension is now voxel number times voxel number, because the information from different images/scans has now been combined. The [threshold](#threshold) function requires an array of r-values (correlation), an array of z-values, and the desired threshold value (e.g., p=0.05).  'Consistent significance' means that, for a particular pair of voxels, the mean z-value (over images/scans) is above threshold *and* that the variability of z-values (over images/scans) is small (standard deviation below mean).  The output consists of thresholded matrices of r- and z-values (with inconsistent and/or insignificant values set to zero), plus a list of voxels that failed to show significant or consistently signifincant correlations. **Thresholding may produce 'orphaned' voxels, without consistently significant correlation to other voxels.**
<figure>
  <img src="https://github.com/cognitive-biology/Parcellation/blob/master/html/corr_mat_th.png" alt="thresholded" width="1000">
  <figcaption>Fig 6. - Correlation matrix of consistently significant voxels of a single run.</figcaption>
</figure>	

4. **Clustering voxels:**

	To cluster the voxels of one particular region, based on their (thresholded) correlation profile, we compute pairwise 'similarity' between profiles, where the correlation coefficient (now computed over voxels) serves as a measure of 'similarity'.  The goal is to assign voxels with 'similar' profiles to the same clusters and voxels with 'dissimilar' profiles to different clusters.  The function [ClusterWithKmeans](#clusterwithkmeans) function uses the K-mean algorithm as implemented by the `kmeans` function of the Matlab.  As the result is slightly stochastic, clustering is repeated 20 times and the results are averaged.  The input required by [ClusterWithKmeans](#clusterwithkmeans) is the thresholded matrix of z-values and the desired number of clusters, N\_cluster.  No further parameter or criterion values are needed.  The number of clusters per region determines the *average* number of voxels per cluster, given the number of voxels in the region.  It must be chosen on scientific grounds (i.e., how fine-grained a parcellation is desired and meaningful).  Dornas & Braun (2018) chose the cluster number for each region such as to obtain a certain average cluster size (e.g., 100 voxels / 0.85 cm<sup>3</sup> gray matter volume, or 200 voxels / 1.7 cm<sup>3</sup>, or 400 voxels / 3.4 cm<sup>3</sup>.  The output of clustering is a list of indices, assigning each voxel in the region to one of the N\_cluster clusters. **'Orphaned' voxels, without consistently significant correlation to other voxels, are assigned cluster index <mark>NaN</mark>.**
<figure>
  <img src="https://github.com/cognitive-biology/Parcellation/blob/master/html/corr_mat_cluster.png" alt="clustered" width="1000">
  <figcaption>Fig 7. - correlation matrix of a single run, clustered.</figcaption>
</figure>

5. **Save new parcellation**
	
	After clustering of all desired regions has been completed, the results can be combined into a new atlas with the [cluster2atlas](#cluster2atlas) function.  The input required by this funciton includes the *nifti* file of the original atlas, its list of regions (ROI), the list of regions that were sub-divided into finer clusters, some properties of *nifti* files, and the path of the directory containing the results of clustering.  More information about this function is provided in the source code [cluster2atlas](#cluster2atlas) and the example demonstration [demo](https://github.com/cognitive-biology/Parcellation/blob/master/examples/demo.m).
<figure>
  <img src="https://github.com/cognitive-biology/Parcellation/blob/master/html/similarity.png" alt="similarity" width="1000">
  <figcaption>Fig 8. - Comparison of the similarity analysis of MD758 vs. S758.</figcaption>
</figure>

## Core routines ##

### open_nii ###

*open_nii* function opens files with .nii format using the *nifti1* toolbox
(nifti.nimh.nih.gov/nifti-1/).

- **Input:** path to the nifti file.
- **Outputs:** 
 1. nifti object file created by the *nifti* function of the *nifti1* toolbox.
 2. Name of the file.
 3. Path to the image folder.
- **Example:**

Using the following command:

``` 
>> [data,FileName,PathName] = open_nii('Path/to/my/image.nii')
```
results in:

```
 data = 
 		NIFTI object: 1-by-1
        dat: [65×22×20×167 file_array]
        mat: [4×4 double]
        mat0: [4×4 double]
 		descrip: 'exampledata'
 
 FileName = 
 		'image.nii'
 
 PathName = 
 		'Path/to/my/'
```

### img2atlas ###

*img2atlas* finds regions to which voxels of an image belong, for a given
atlas, i.e. this function fits the input image input the desired atlas.

- **Inputs:** 
 1. Path to the nifti file of the desired atlas.
 2. Path to the list of regions of the desired atlas.
 3. Path to the nifti file of the image.
 4. (optional) save the output with the given name.
- **Output:** N-by-4 cell array containing the regions' ID, name, voxels ID inside the region, data of voxels inside the region.
- **Example:** 

Using the following command:

```
>> atlasnii = 'Path/to/atlas.nii';
>> atlaslist = 'Path/to/atlas/ROI_list.mat';
>> image = 'Path/to/my/image.nii'; 
>> savename = 'myimage'; 
>> out_data = img2atlas(atlasnii,atlaslist,image,'save',savename)
```
results in:

```
fitting exampledata1.nii to atlas ...
saving example1_atlas_fitted ... 

out_data = 
		3×4 cell array
		{[0]}    {0×0 char   }    {25675×1 double}    {167×25675 double}
    	{[1]}    {'Angular_L'}    { 1173×1 double}    {167×1173  double}
    	{[2]}    {'Angular_R'}    { 1752×1 double}    {167×1752  double}
```

### local_corr ###

*local_corr* calcuates the correlation matrix and p-values assigned to it along with the Fisher Z-transformed values.

- **Inputs:**
 1. Region number for which the correlation matrix is being calculated.
 2. A 1-by-N structure array containing the data of the atlas-fitted images, where N is the number of images.
 3. TR range for which the correlation matrix will be calculated.
 4. (optional) save the output with the given name.
- **Outputs:**
 1. A 1-by-N cell array of correlation matrices.
 2. A 1-by-N cell array of p-values assigned to each element of the correlation matrices.
 3. A 1-by-N cell array of the Fisher Z-transformed form of the correlation matrices.
- **Example:**

Using the following command:

```
>> TR_range = 17:166; 
>> region = 1; 
>> data1 = img2atlas(atlasnii,atlaslist,image1);
>> data2 = img2atlas(atlasnii,atlaslist,image2);
>> all_images(1).out_data = data1;
>> all_images(2).out_data = data2;
>> [rho,pval,zscore] = local_corr(region,all_images,TR_range,'save', ...
	'name_to_Save')
```
results in:

```
calculating correlation profile: 1 out of 2 ...
calculating correlation profile: 2 out of 2 ...

rho =

  1×2 cell array

    {1173×1173 double}    {1173×1173 double}


pval =

  1×2 cell array

    {1173×1173 double}    {1173×1173 double}


zscore =

  1×2 cell array

    {1173×1173 double}    {1173×1173 double}
```

### threshold ###

*threshold* gets the correlations and Fisher Z-transformed matrices and applies the threshold on them by considering the significacy and consistency of the correlations.

- **Inputs:**
 1. Correlation matrices of all runs.
 2. Fisher Z-transformation form of the correlation matrices.
 3. Threshold.
 
- **Outputs:**
 1. Thresholded correlation matrices.
 2. Thresholded Fisher Z-transformation form of the correlation matrices.
 3. Indices of the arrays that did have been filtered out, i.e. insignificant or  inconsistent elements.
 
- **Example:**
  
Previously, the correlation and Fisher Z-transformed matrices were cell arrays.
  
```
zscore =

  1×2 cell array

    {1173×1173 double}    {1173×1173 double}

rho =

  1×2 cell array

    {1173×1173 double}    {1173×1173 double}
```
This should change by applying the `cell2mat` function:

```  
>> R = cell2mat(rho);
>> Z = cell2mat(zscore);
```
Then using the following command:

```
>> th = 0.13;
>> [R_th,Z_th,insignificant_index] = threshold(R,Z,th);
```
results in:

```

>> size(R_th)

ans =

        1173        2346
        
>> size(Z_th)

ans =

        1173        2346

>> size(insignificant_index)

ans =

        1173        1173
```

### ClusterWithKmeans ###

*ClusterWithKmeans* performs kmean clustering on a set of data with a set of pre-defined parameters.

- **Inputs:**
 1. N-by-M matrix (in the case of parcellation, thresholded correlation matrices.)
 2. Number of clusters.

- **Outputs:**
 1. Cluster indices.
 2. Cluster indices of non-empty elements.
 3. Number of clusters.
 4. Distnaces of every point to the centroid of the clusters.
 
- **Example:**

Using the following command:

```
>> nclusters = 5;
>> [Idx, Tidx, nc,Dis] = ClusterWithKmeans(R_th,nclusters);
kmean clustering started ... 
done!
```
results in:

```
>> size(Idx)

ans =

        1173           1

>> size(Tidx)

ans =

        1173           1
        
>> size(Dis)

ans =

        1173           5
        
>> nc

nc =

     5
```

### save_nii ###

SAVE_NII saves files with .nii format using the NifTI Toolbox
(nifti.nimh.nih.gov/nifti-1/).

- **Inputs:**
 1. Data the should be saved as a nifti file.
 2. The name of the saved file (contains .nii).
 3. Properties structure of the nifti file.
- **Output:** a nifti file.

- **Example:**

To save a set of data as a nifti file, the input data, the file name and the properties of the nifti file should be defined:

```
>> data = Idx;
>> size(data)
ans =

        1173           1
        
>> filename = 'name_of_my_file.nii';
>> prop

prop = 

  struct with fields:

            mat: [4×4 double]
     mat_intent: 'Aligned'
           mat0: [4×4 double]
    mat0_intent: 'Aligned'
            dim: [65 22 20]
          dtype: 'INT16-BE'
         offset: 352
      scl_slope: 1
      scl_inter: 0
       descript: 'my description'
         timing: []
```
Afterwards, the following command can be used to save the data as a nifti file:
       
```
>> save_nii(data,filename,prop)
```

### cluster2atlas ###

*cluster2atlas* gets a reference atlas and clusters created by functional
clustering and maps the clusters to the given atlas.

- **Inputs:**
 1. A cell array containing the path to all cluster files.
 2. Path to the nifti file of the image.
 3. Path to the list of regions of the reference atlas.
 4. Regions.
 5. (optional) name to save the mapped cluster data and list of regions as a *.mat* file.
 6. (optional) name to save the mapped cluster as a nifti file.
- **Outputs:**
 1. Data of the clusters mapped to the reference atlas.
 2. List of regions (ROI).
- **Example:**

To save the new parcellation, after clustering the voxels, the path to the clusters, path to the nifti file and list of ROIs of the reference atlas should be indicated:

```
>> atlasnii = 'Path/to/atlas.nii'; 
>> atlaslist = 'Path/to/atlas/ROI_list.mat';
>> cluster(1) = {'path/to/cluster1'}; 
>> cluster(2) = {'path/to/cluster2'}; 
>> regions = 1:2;
```
Later, the new atlas can be saved as a nifti file and its list of ROIs can be saved at the same time, using:

```
>> [data,ROI] = cluster2atlas(cluster,atlasnii,atlaslist,regions ...
    ,'save','my_desired_name','nii','my_desired_name.nii');
```

which results in:

```
>> size(data)

ans =

    65    22    20

>> ROI

ROI = 

  1×13 struct array with fields:

    ID
    Nom_C
    Nom_L
```

## Quality assessment routines##
### tsnr ###

*tsnr* calculates the signal to noise ratio for a set of given images.

- **Inputs:**
 1. Region numbers that should be involved in assessment of the signal to noise ratio.
 2. A 1-by-N structure array containing the data of the atlas-fitted images, where N is the number of images.
 3. TR range for which the correlation matrix will be calculated.
 4. (optional) save the outputs with the given name.
- **Outputs:**
 1. Signal to noise ratio.
 2. Average of the signal strength.
 3. Standard deviation of the signal strength.
- **Example:**

To assess the quality of the images, one can you the function *tsnr* for a set of atlas-mapped images as follows:

```
>> TR_range = 17:166; 
>> regions = 1:2; 
>> data1 = img2atlas(atlasnii,atlaslist,image1);
>> data2 = img2atlas(atlasnii,atlaslist,image2);
>> all_images(1).out_data = data1;
>> all_images(2).out_data = data2;
>> [snr_t,mu_t,sigma_t] = tsnr(regions,all_images,TR_range,'save', ...
	'name_to_Save')
```

### similarity ###
*similarity* function provides means of testing the finer-parcellation quality by considering the similarity and dissimilarity of the correlation profile of voxels inside each cluster through the cluster homogeneity and Silhouette coefficient.

- **Inputs:**
 1. A M-by-N matrix representing the average correlation profile of each voxel inside a region, where M is number of voxels and N is number of runs.
 2. A 1-by-M vector representing the cluster indices of M voxels of a region.
- **Outputs:**
 1. Similarity of voxel pairs (M-by-M).
 2. Dissimilarity of voxel pairs (M-by-M).
 3. Cluster homogeneity (M-by-1).
 4. Silhouette coefficient (M-by-1).
- **Example:**

To get the finer-parcellation quality of a desired region, first the files containing the Fisher Z-transformation value and the indices of the clusters for each voxel, should be loaded.

```
>> load('path/to/my/zscore_of_the_region.mat')
>> load('path/to/my/indices_of_clusters_of_the_region.mat')
```

Then, one should average the z-scores over voxels after eliminating the possible *Inf* or *NaN* values.

```
>> Z = cell2mat(zscore);
>> Z(isinf(Z)|isnan(Z)) = 0;
>> Z = reshape(Z,size(Z,1),size(Z,1),size(Z,2)/size(Z,1));
>> avg_Z = squeeze(nanmean(Z),1);
```
 Finally, one can use the *similarity* function to get the desired parcellation quality assessment measures.
 
```
>> [S,D,CH,SC] = similarity(avg_Z,Idx);
```
