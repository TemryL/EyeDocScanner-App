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
        .alert("CSV file written successfully.", isPresented: $fileController.showAlert) {
            Button("Dismiss", action: {})
            Button("Open", action: {fileController.openCSV()}).keyboardShortcut(.defaultAction)
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
        guard let structuredData = await client.sendRequest(jsonData: data) else {
            return
        }
        fileController.writeCSV(data: structuredData)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(FileController())
            .environmentObject(HttpClient())
    }
}
