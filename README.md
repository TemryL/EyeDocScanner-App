<p align="center">
  <img src="https://github.com/TemryL/EyeDocScanner_App/assets/99132608/9086edf1-802c-4c1b-a352-fb4bd27d1d3a" alt="EyeDocScanner App Icon" width="150" height="150" style="border-radius: 50%;">
</p>

<h1 align="center">EyeDocScanner App</h1>

An iOS app that allows users to efficiently scan medical report documents from Alcon EX500 or Sophtalmo software. The app automatically extracts relevant information and presents it in a structured and normalized CSV document.


## Features

- **Scan Medical Reports**: Easily scan medical report documents using the device's camera or import images from the gallery.
- **Compatibility**: Supports medical report documents from Alcon EX500 and Sophtalmo software.
- **Information Retrieval**: Automatically extracts key information such as patient details and examination data.
- **CSV Export**: Generates a structured and normalized CSV document containing the extracted data.

## Installation

To use EyeDocScanner on your iOS device or simulator, follow these simple steps:

1. Clone this repository to your local machine or download the source code as a ZIP file.
2. Open the project in Xcode.
3. Build the app and run it on your iOS device or preferred simulator.

## Getting Started

To get started with the app, follow these instructions:

1. Launch EyeDocScanner on your iOS device.
2. From the main screen, choose the option to "Scan" a medical report.
3. Use the device's camera to capture a clear image of the medical report.
4. The app will automatically process the document and extract the relevant information.
5. Once the extraction is complete, you can export the data as a structured CSV document.

## Requirements

- iOS 16.0 or higher
- Compatible with iPhone and iPad

## Documentation
This app extracts OCR data from the scanned document in JSON format and sends it to the [EyeDocScanner API](https://github.com/TemryL/EyeDocScanner_API) through HTTP requests. The API process the OCR data and return the structured data in JSON format to the IOS app. Finally, the results are stored locally on the iPhone in CSV format.

The concept, inner workings and performance of the system are explored in the following presentation:  
[S. Pham-Ba, *VITA'App, Picture to Structured text, Tech meeting*, 2023](https://github.com/TemryL/EyeDocScanner_API/files/12208931/2023.03.06.-.VITA.App.Tech.meeting.pdf).

## Demo

https://github.com/TemryL/EyeDocScanner_App/assets/99132608/d5334ff2-6df6-45a9-a082-35e18f23c045

## Limitations and Next Steps

While EyeDocScanner performs great in extracting accurate information from well-taken medical report images, it may encounter some limitations when dealing with images that have suboptimal OCR results. In such cases, the resulting CSV document might contain errors and typos. To enhance the app's robustness and address these challenges, we propose the following next steps:

### Multiple Scans and Data Consistency

To improve accuracy, we recommend implementing the ability for users to scan the same medical report multiple times. The app can then extract OCR data from each scan and cross-reference the results. By performing a consensus or voting mechanism, the app can determine the most reliable data for each cell in the CSV file. This approach helps minimize errors caused by occasional OCR inaccuracies.

### Video-Based OCR and Data Aggregation

Another promising avenue is enabling users to capture a video of the medical report rather than taking a single image. The app can then process each frame of the video individually, extracting OCR data for each frame. By aggregating data from multiple frames and applying voting or consensus algorithms, the app can achieve more accurate and consistent results for the final CSV document.

### Error Detection and Correction

Implementing an error detection and correction mechanism within the app can also be valuable. The app can incorporate domain expertise to validate and correct the OCR results. Many of the values obtained from medical reports are expected to follow specific physical properties and constraints, such as correct units, consistent sign conventions, or reasonable order of magnitude. By identifying potential discrepancies or inconsistencies in the extracted data, the app can prompt users to verify or correct specific entries, further improving the overall data quality. 

