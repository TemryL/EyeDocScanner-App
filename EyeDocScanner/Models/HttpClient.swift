//
//  HttpClient.swift
//  EyeDocScanner
//
//  Created by Tom MERY on 18.03.23.
//

import Foundation

class HttpClient: ObservableObject {
    //let url = URL(string: "https://vitademo.epfl.ch/scanner/")!
    let url = URL(string: "http://172.20.10.3:8080")!
    
    @Published var showAlert = false
    var alertContent: String = "N/A"
    
    func sendRequest(jsonData: Data) async -> [[String: String]]? {
        var request = URLRequest(url: self.url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            let (data, response) = try await URLSession.shared.upload(for: request, from: jsonData)
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 480 {
                    self.alertContent = "Could not find a matching reader. \nCurrently supported softwares: \n \(SUPPORTED_SOFTWARES.joined(separator: ", "))."
                    self.showAlert = true
                    return nil
                }
            }

            if let structuredData = parseResponse(data: data) {
                return structuredData
            }
            else {
                self.alertContent = "Could not parse the received data. \nTry again."
                self.showAlert = true
                return nil
            }
        }
        catch {
            self.alertContent = "Request to server failed. \nVerify your internet connexion."
            self.showAlert = true
            return nil
        }
    }
    
    func parseResponse(data: Data) -> [[String: String]]? {
        do {
            let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as! [[String: String]]
            return jsonArray
        } catch {
            print("Error decoding JSON: \(error.localizedDescription)")
            return nil
        }
    }
}
