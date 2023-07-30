# EyeDocScanner App

An iOS app that allows users to efficiently scan medical report documents from Alcon EX500 or Sophtalmo software. The app automatically extracts relevant information and presents it in a structured and normalized CSV document.

![icon](https://github.com/TemryL/EyeDocScanner_App/assets/99132608/9086edf1-802c-4c1b-a352-fb4bd27d1d3a)

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

## Limitation and next steps


