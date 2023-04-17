//
//  ContentView.swift
//  EyeDocScanner
//
//  Created by Tom MERY on 10.03.23.
//

import SwiftUI

struct ContentView: View {
    @State private var showScannerSheet = false
    @State private var ocrData: Data?
    @State private var saveAlert: Bool = false
    @State private var fileName: String = ""
    @State private var structuredData: [[String: String]] = [["":""]]
    @EnvironmentObject private var fileController: FileController
    @EnvironmentObject private var client: HttpClient
    
    var body: some View {
        NavigationView{
            VStack {
                Button("Scan",
                       action: {self.showScannerSheet = true}
                )
            }
            .sheet(isPresented: $showScannerSheet, content: {
                self.makeScannerView()
            })
            .onChange(of: ocrData) { jsonData in
                if let data = jsonData {
                    Task {
                        await makeServerRequest(data: data)
                    }
                }
            }
        }
        .alert(isPresented: $client.showAlert) {
            Alert(
                title: Text("Server error"),
                message: Text(client.alertContent),
                dismissButton: .default(Text("Got it!"))
            )
        }
        .alert("Data ready to save", isPresented: $saveAlert) {
            TextField("Enter a file name ", text: $fileName)
            Button("Dismiss", action: {})
            Button("Save") {
                fileController.writeCSV(fileName:fileName, data: structuredData)
            }
        }
        .alert(fileController.alertContent, isPresented: $fileController.showAlert) {
            if fileController.alertContent == "File written successfully" {
                Button("Dismiss", action: {})
                Button("Open", action: {fileController.openCSV()}).keyboardShortcut(.defaultAction)
            }
            else {
                Button("Dismiss", action: {})
            }

        }
    }
    
    private func makeScannerView() -> ScannerView {
        ScannerView(completion: {
            jsonData in
            self.ocrData = jsonData
            self.showScannerSheet = false
        })
    }
    
    func makeServerRequest(data: Data) async {
        guard let response = await client.sendRequest(jsonData: data) else {
            return
        }
        structuredData = response
        saveAlert = true
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(FileController())
            .environmentObject(HttpClient())
    }
}
