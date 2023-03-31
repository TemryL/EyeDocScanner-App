//
//  OCR.swift
//  EyeDocScanner
//
//  Created by Tom MERY on 10.03.23.
//

import Foundation
import UIKit
import Vision
import VisionKit


let PICTURE_SPLITS = 3
let PICTURE_SPLIT_SIZE = 0.5 // size of cropped region, between 0 and 1


struct OcrRequest {
    var request: VNRecognizeTextRequest
    
    init(_ croppedOcrResults: CroppedOcrResults, _ dispatchGroup: DispatchGroup) {
        request = VNRecognizeTextRequest { (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
        
            for observation in observations {
                guard let topCandidate = observation.topCandidates(1).first else { return }
                var detectedText = DetectedText(text: topCandidate.string)
                
                // Create range for bounding box detection
                let startIndex = topCandidate.string.startIndex
                let endIndex = topCandidate.string.endIndex
                let range = startIndex ..< endIndex
                
                do {
                    let bbox: VNRectangleObservation = try topCandidate.boundingBox(for: range)!
                    
                    detectedText.bbox.bottomLeft  = Point(x: bbox.bottomLeft.x,  y: bbox.bottomLeft.y)
                    detectedText.bbox.bottomRight = Point(x: bbox.bottomRight.x, y: bbox.bottomRight.y)
                    detectedText.bbox.topLeft     = Point(x: bbox.topLeft.x,     y: bbox.topLeft.y)
                    detectedText.bbox.topRight    = Point(x: bbox.topRight.x,    y: bbox.topRight.y)
                } catch {
                    print("Could not retrieve bounding box for text \(topCandidate.string)")
                } // Cannot get bounding box
                
                croppedOcrResults.detectedTextList.append(detectedText)
            }
            
            DispatchQueue.main.async {
                dispatchGroup.leave()
            }
        }
        
        request.recognitionLevel = .accurate
        request.recognitionLanguages = ["en-US", "en-GB", "fr-FR"]
        request.usesLanguageCorrection = true
    }
}


/** Calls functions to save image, perform OCR and save OCR data */
func processImage(_ image: UIImage, completion: @escaping((Data?) -> Void)) {
    guard let cgImage = image.cgImage else { return }
    
    let fileController = FileController()
    let filename = fileController.generateNewFilename()
    let imagePath = fileController.generatePath(filename, "jpg")
    fileController.saveImage(image, imagePath)
    generateOcrJson(cgImage) { data in
        completion(data)
    }
}


/** Crop image into multiple small parts and perform OCR on them */
func generateOcrJson(_ cgImage: CGImage, completion: @escaping((Data?) -> Void)) {
    var results: [CroppedOcrResults] = []
    let dispatchGroup = DispatchGroup()
    
    for xSplit in 0 ..< PICTURE_SPLITS {
        for ySplit in 0 ..< PICTURE_SPLITS {
            // Crop image
            let shiftDist = (PICTURE_SPLITS == 1) ? 0 : (1 - PICTURE_SPLIT_SIZE) / Double(PICTURE_SPLITS - 1)
            let xShift = Double(xSplit) * shiftDist
            let yShift = Double(ySplit) * shiftDist
            
            // yShift is defined from an origin at the bottom left, to be
            // consistent with OCR bounding boxes.
            // cropRegion assumes an origin at the top left. Hence, the y axis
            // must be inverted.
            let cropRegion = CGRect(
                x: xShift * Double(cgImage.width),
                y: (1 - yShift - PICTURE_SPLIT_SIZE) * Double(cgImage.height),
                width: PICTURE_SPLIT_SIZE * Double(cgImage.width),
                height: PICTURE_SPLIT_SIZE * Double(cgImage.height)
            )
            
            guard let croppedImage = cgImage.cropping(to: cropRegion)
            else {
                print("Error: Could not crop image")
                return
            }
            
            // Create container for OCR results
            let croppedOcrResults = CroppedOcrResults(cropRegion: CropRegion(
                x: xShift,
                y: yShift,
                width: PICTURE_SPLIT_SIZE,
                height: PICTURE_SPLIT_SIZE
            ))
            results.append(croppedOcrResults)
            
            // Create and perform OCR request
            let requestHandler = VNImageRequestHandler(cgImage: croppedImage, options: [:])
            let ocrRequest = OcrRequest(croppedOcrResults, dispatchGroup)
            dispatchGroup.enter()
            do {
                try requestHandler.perform([ocrRequest.request])
            } catch {
                print(error)
            }
        }
    }
    
    // When all requests are processed, save JSON
    dispatchGroup.notify(queue: .main) {
        // Save detected text into file text in local file system
        let jsonData = exportJson(data: results)
        completion(jsonData)
    }
}

