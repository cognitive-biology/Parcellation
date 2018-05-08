# MD758 Functional Sub-Parcellation

**MD758 functional sub-parcellation toolbox** provides a set of [MATLAB](https://mathworks.com/products/matlab) routines to refine a coarse parcellation of the human brain into a finer functional parcellation.
For example, these routines could be used functionally sub-divide an anatomically defined region of interest, such as entorhinal and parahippocampal cortex.  We have used these routines to subdivide each of the 90 AAL regions (with an average gray matter volume of 14 cm3) into smaller, functionally devined parcels (with an average gray matter volume 1 cm3). Importantly, this method is NOT suitable for sub-dividing large, functionally heterogeneous brain volumes (such as an entire lobe, or an entire hemisphere).  The reason is that consistently significant temporal correlations between individual brain voxels (on which this method is based) are typically observed only within functionally homogeneous regions.  The sub-parcellation employs functional MRI data acquired from resting observers.  

## Contents ##

1. [Citing MD758](#citing-md758)
2. [Requirements](#requirements)
3. [How to use?](#how-to-use)
4. [Core codes](#core-codes)

## Citing MD758 ##

MD758 functional sub-parcellation method has been developed and published by:

Dornas, J. V., & Braun, J. (2018). Finer parcellation reveals detailed correlational structure of resting-state fMRI signals. Journal of neuroscience methods, 294, 15-33. <https://doi.org/10.1016/j.jneumeth.2017.10.020>

## Requirements ##

In order to run the provided example code, you will need:

- MATLAB 
- [Statistics and Machine Learning Toolbox](https://www.mathworks.com/products/statistics.html)
- nifti1 matlab toolbox (download [here](https://nifti.nimh.nih.gov/nifti-1/) or [here](https://sourceforge.net/projects/niftilib/files/niftimatlib/niftimatlib-1.0/niftimatlib-1.0.tar.gz/download) )

In order to perform a functional sub-parcellation, you will need functional scans from resting observers, as well as a coarse atlas defining your anatomical regions of interest (for example, anatomical regions of the AAL parcellation).

## How to use ##

Download or clone MD758 functional sub-parcellation [here](https://github.com/cognitive-biology/Parcellation.git). Don't forget to [set the path](https://mathworks.com/help/matlab/matlab_env/add-remove-or-reorder-folders-on-the-search-path.html) of the toolbox in your matlab directory.

Then you can follow the pipeline as discussed below:

![](https://github.com/cognitive-biology/Parcellation/blob/master/html/pipeline.png)

Before following the pipeline, you can read the [core codes](#core_codes) and also run the [demo](https://github.com/cognitive-biology/Parcellation/blob/master/examples/demo.m) file created as an example of how you can use this toolbox.

**WARNING:** Due to large amount of data that fMRI images contain, this process is memory consuming. Make sure to save any unsaved processes before running this program. 

### Pipeline ###

After having your fMRI images preprocessed, you can take the following steps to get a finer functional parcellation:

1. **Map to atlas:** 

	First, you have to map your images to a predefined atlas. You should keep it in mind that your desired atlas and images must be normalized in the same space, e.g. MNI space. In order to be able to map your images, the desired atlas should be in *nifti* format and should have a list of regions of interest (ROI) in *.mat* format. The atlas list of ROI file, contains a variable named as **ROI**. This variable is a structure array of the size equal with number of regions. Fields assigned to it are: <mark>ROI.ID, ROI.Nom\_C and ROI.Nom\_L</mark>, which are the ID of voxels (same as the values assigned to them in the nifti file of the atlas), regions' labels and regions' names.
	
	As an example, check [ROI\_MNI\_MD758\_List.mat](https://github.com/cognitive-biology/Parcellation/tree/master/atlas/MD758)
	
	```
ROI = 

  		1×758 struct array with fields:

    		ID
    		Nom_C
    		Nom_L
	``` 
	After preparing your atlas in the format mentioned above, you can map images to the atlas By using [img2atlas](#img2atlas) function. The output of this function is a variable named as **out_data** which is a cell array of the size N+1-by-4 where the first row contains the data of the voxels outside of the ROIs  of the atlas. Remaining rows, contain the data of the voxels for each regions of interest, in the same order as the *ROI_list.mat* file. 
	
	The columns of the out_data variable are the regions' ID, name, Indices of the voxels inside the region and their correspondic data (single number for structural data and time series for the functionla data), respectively. For example, in the [demo](https://github.com/cognitive-biology/Parcellation/blob/master/examples/demo.m) you will get the following data:
	
	```
	out_data =

  		3×4 cell array

    		{[0]}    {0×0 char   }    {25675×1 double}    {167×25675 double}
    		{[1]}    {'Angular_L'}    { 1173×1 double}    {167×1173  double}
    		{[2]}    {'Angular_R'}    { 1752×1 double}    {167×1752  double}
	``` 
	In order to be able to proceed to the next step, all the data mapped to the atlas should be included in one variable with the <mark>out_data</mark> field.

	```
	images = 

	  1×2 struct array with fields:

   		 out_data

	``` 
	
2. **Correlation Profile of voxels:**
	
	After all the images have been mapped to the desired and included in one variable with the out\_data as its field, you can calculate the local correlation profile of each voxel using [local_corr](#local_corr) function, where you have to indicate the region number which will be used for getting the local correlation profile and the TR range that you want to include in your analysis. As a result, correlation matrix, p-value assigned to each element of the correlation matrix and the Fisher Z-transformation form of them are generated as cell arrays of the size equal with number of images included in your analysis, i.e. size of the input data in form of structure array with *out_data* field.

3. **Keeping significant voxels:**

	Once the local correlation profile of the voxels of a region is calculated, one can filter out the voxels with insignificant or inconsistently significant voxels, by applying a threshold on them using the [threshold](#threshold) function. For this purpose, the correlation profile matrices and their Fisher Z-transformed version - which have been calculated in previous step- should be changed from their cell array form to an ordinary array (matrix) using `cell2mat` function. Then these two matrices, along with the threshold, should be inputted in the [threshold](#threshold) function. This will result in 3 outputs, thresholded correlation matrix, thresholded Fisher Z-transformed matrix and the indices of the voxels that did not pass the sanity check.
	
4. **Clustering the voxels:**

	To get the clusters of a region based on the correlation profile of the significant voxels, [ClusterWithKmeans](#clusterwithkmeans) function uses Kmean clustering using the `kmeans` function of the matlab with the correlation as the distance between data points and limits number of iterations to 20. To run this code, users should input the thresholded correlation matrix and the number of clusters they want the data points to be clustered in. MD758 uses (on average) 200 voxels per cluster. Then, the [ClusterWithKmeans](#clusterwithkmeans) function will generate the indices of the clusters for each voxel. **For voxels with no significant correlation values, <mark>NaN</mark> has been assigned as their index of cluster.**

5. **Save new parcellation**
	
	After the clustering has been finished for all the desired regions, the new atlas can be saved using the [cluster2atlas](#cluster2atlas) function, where the nifti file of the original atlas and its list of regions (ROI), in addition to the code of the regions used for finer parcellation, properties of the nifti file and the path to the files containing the clusters, will be inputted. 

	For more information on how to use this function, look at [cluster2atlas](#cluster2atlas) and the [demo](https://github.com/cognitive-biology/Parcellation/blob/master/examples/demo.m) file.

## Core Codes ##

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