//
//  ScannerView.swift
//  EyeDocScanner
//
//  Created by Tom MERY on 10.03.23.
//

import VisionKit
import SwiftUI

struct ScannerView: UIViewControllerRepresentable {
    private let completionHandler: (Data?) -> Void
     
    init(completion: @escaping (Data?) -> Void) {
        self.completionHandler = completion
    }
     
    typealias UIViewControllerType = VNDocumentCameraViewController
     
    func makeUIViewController(context: UIViewControllerRepresentableContext<ScannerView>) -> VNDocumentCameraViewController {
        let viewController = VNDocumentCameraViewController()
        viewController.delegate = context.coordinator
        return viewController
    }
     
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: UIViewControllerRepresentableContext<ScannerView>) {}
     
    func makeCoordinator() -> Coordinator {
        return Coordinator(completion: completionHandler)
    }
     
    final class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        private let completionHandler: (Data?) -> Void
         
        init(completion: @escaping (Data?) -> Void) {
            self.completionHandler = completion
        }
         
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            print("Document camera view controller did finish with ", scan)
            guard scan.pageCount >= 1 else {
                controller.dismiss(animated: true)
                return
            }
            
            var images = [UIImage]()
            for i in 0 ..< scan.pageCount {
                let image = scan.imageOfPage(at: i)
                images.append(image)
            }
            
            processImages(images) { jsonData in
                self.completionHandler(jsonData)
            }
            
            completionHandler(nil)
        }
         
        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            completionHandler(nil)
        }
         
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            print("Document camera view controller did finish with error ", error)
            completionHandler(nil)
        }
    }
}
