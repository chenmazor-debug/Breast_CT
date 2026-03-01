# Breast CT Image Processing
This project implements an HDR-based image processing pipeline for breast CT images.
The algorithm enhances contrast in soft tissue regions while compressing the overall dynamic range of the CT image.

The code was developed in MATLAB and processes a single CT slice per ru.
Input images are expected to be in DICOM (.dcm) format.

---

# Requirements
* MATLAB R202 or newer
* MATLAB Image Processing Toolbox

---

# Project Structure
```
project/
│
├── main.m
├── Functions/
│   Image preprocessing and HDR compression functions
│
├── results/
│   Output collage images
│
│   └── Tiles/
│       Individual tiles extracted from the collage
│
└── README.md
```

# How to Run

1. Open MATLAB.
2. Navigate to the project folder.
3. Run:
main.m

During execution the program will guide you through several steps:

1. Choose whether to save the results.
2. If saving is enabled, select an output directory.
3. Select a CT slice (.dcm file) to process.
4. Choose whether to save the results with a unique name or a default name.
5. Select the image windows you want to export as tiles.

# Input

* A single CT slice in DICOM (.dcm) format.

# Output

The program generates:

* A collage image containing:

  * the original CT image
  * selected display windows
  * the HDR processed image

* Individual tiles extracted from the collage according to the selected windows.

Output files are saved automatically:
results/
   collage_image
   Tiles/
       individual tile images

# Notes

* The algorithm processes one CT slice per run.
* The user selects input files and output folders using MATLAB dialog windows.
* All processing is fully automatic once the input slice is selected.
* The code automatically loads all required subfolders.
