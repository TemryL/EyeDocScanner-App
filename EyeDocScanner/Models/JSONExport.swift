//
//  JSONExport.swift
//  EyeDocScanner
//
//  Created by Tom MERY on 10.03.23.
//

import Foundation


struct Point: Codable {
    var x: Double = 0
    var y: Double = 0
}


struct BoundingBox: Codable {
    var bottomLeft:  Point = Point()
    var bottomRight: Point = Point()
    var topLeft:     Point = Point()
    var topRight:    Point = Point()
}


struct DetectedText: Codable {
    var text: String
    var bbox: BoundingBox = BoundingBox()
}


struct CropRegion: Codable {
    var x: Double
    var y: Double
    var width: Double
    var height: Double
}


// This is a class, for it to be passed by reference
class CroppedOcrResults: Codable {
    var cropRegion: CropRegion
    var detectedTextList: [DetectedText] = []
    
    init(cropRegion: CropRegion) {
        self.cropRegion = cropRegion
    }
}


func exportJson(data: [CroppedOcrResults]) -> Data? {
    /* Output detected text in JSON string
    format:
    [
      {
        cropRegion: {
          x: Double,
          y: Double,
          width: Double,
          height: Double
        },
        detectedTextList: [
          {
            text: String,
            bbox: {
              bottomLeft:  {x: Double, y: Double},
              bottomRight: {x: Double, y: Double},
              topLeft:     {x: Double, y: Double},
              topRight:    {x: Double, y: Double}
            }
          },
        ]
      },
    ]
    */
    do {
        let jsonEncoder = JSONEncoder()
        let jsonData = try jsonEncoder.encode(data)
//        let jsonString = String(data: jsonData, encoding: .utf8)!
//        let path = to.path
//        try jsonString.write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
//        print("File written successfully")
        return jsonData
        
    } catch {
        print("Error exporting JSON: \(error)")
        return nil
    }
    
}
