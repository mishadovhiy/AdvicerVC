//
//  Request.swift
//  AdvicerCV
//
//  Created by Mykhailo Dovhyi on 31.03.2025.
//

import Foundation

extension NetworkModel {
    struct Request {
        var request:URLRequest?
        
        init(_ input:NetworkRequest) {
            if !input.isValid {
                request = nil
                return
            }
            switch input {
            case .advice(_):
                request = URLRequest(url: .init(string: Keys.openAIChatURL.rawValue)!)
                
                let prompt = input.promt
                print(prompt, " openaiprompt")
                let jsonBody: [String: Any] = [
                    "model": "gpt-3.5-turbo",
                    "messages": [
                        ["role": "system", "content": "You are a helpful assistant."],
                        ["role": "user", "content": prompt]
                    ],
                    "max_tokens": 4096
                ]
                guard let httpBody = try? JSONSerialization.data(withJSONObject: jsonBody, options: []) else {
                    print("Error serializing JSON")
                    request = nil
                    return
                }
                let token = Keys.openAIToken.rawValue
                
                request?.httpMethod = "POST"
                request?.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request?.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                request?.httpBody = httpBody
                
            case .support(let supportInput):
                let toDataString = "emailTitle=\(supportInput.title)&emailHead=\(supportInput.header)&emailBody=\(supportInput.text)"
                guard let url:URL = .init(string: "https://www.mishadovhiy.com/apps/" + "budget-tracker-db/sendEmail.php?\(toDataString)") else {
                    request = nil
                    return
                }
                request = URLRequest(url: url)
                request?.httpMethod = "POST"
            }
            
        }
        
        func perform(data:String = "", completion:@escaping(_ data: Data?)->()) {
            if request?.httpMethod != "POST" {
                self.uploadRequest(data: data, completion: completion)
            } else {
                self.performRequest(completion: completion)
            }
        }
        
        fileprivate func performRequest(data:String = "", completion:@escaping(_ data: Data?)->()) {
            guard let request else {
                completion(nil)
                return
            }
            let session = URLSession.shared.dataTask(with: request) { data, response, error in
                completion(data)
            }
            session.resume()
        }
        
        fileprivate func uploadRequest(data:String = "", completion:@escaping(_ data: Data?)->()) {
            guard let request else {
                completion(nil)
                return
            }
            let data = data.data(using: .utf8)
            
            let uploadJob = URLSession.shared.uploadTask(with: request, from: data) { data, response, error in
                let returnedData = NSString(data: data ?? .init(), encoding: String.Encoding.utf8.rawValue)
                print(returnedData, " egrfweds ")
                if error != nil {
                    completion(nil)
                    return
                }
                completion(data)
            }
            uploadJob.resume()
        }
        
    }
}
