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
        VStack(spacing: 20) {
             Text("EyeDocScanner")
                 .font(.largeTitle)
                 .fontWeight(.bold)
                 .padding(.top, 40)
             Spacer()
             Button(action: {
                 self.showScannerSheet = true
             }) {
                 Text("Scan")
                     .frame(width: 200, height: 50)
                     .background(.blue)
                     .foregroundColor(.white)
                     .font(.title)
                     .cornerRadius(10)
             }
             Spacer()
             Text("Supported Software:")
                 .font(.caption)
                 .foregroundColor(.gray)
             
             HStack(spacing: 10) {
                 Spacer()
                 ForEach(SUPPORTED_SOFTWARES, id: \.self) { software in
                     Text(software)
                         .font(.caption)
                         .padding(8)
                         .background(Color.green)
                         .foregroundColor(.white)
                         .cornerRadius(10)
                 }
                 Spacer()
             }
         }
         .padding(.horizontal, 30)
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
        .alert(isPresented: $client.showAlert) {
            Alert(
                title: Text("Server Error"),
                message: Text(client.alertContent),
                dismissButton: .default(Text("Got it!"))
            )
        }
        .alert("Data Ready to Save", isPresented: $saveAlert) {
            TextField("Enter a File Name ", text: $fileName)
                .padding()
            
            Button("Dismiss", action: {})
                .padding()
            
            Button("Save") {
                fileController.writeCSV(fileName:fileName, data: structuredData)
            }
            .padding()
            .keyboardShortcut(.defaultAction)
            
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
