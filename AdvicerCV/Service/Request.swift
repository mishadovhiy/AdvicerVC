//
//  Request.swift
//  AdvicerCV
//
//  Created by Mykhailo Dovhyi on 31.03.2025.
//

import Foundation

extension NetworkModel {
    struct Request {
        static func openAIRequest(_ input:PromtOpenAI) -> URLRequest? {
            if !input.isValid {
                print("prompt has nil")
                return nil
            }
            var request = URLRequest(url: .init(string: Keys.openAIChatURL.rawValue)!)
            
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
                return nil
            }
            let token = Keys.openAIToken.rawValue
            
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpBody = httpBody
            return request
        }

    }
    
    struct PerformRequest {
        static func request(_ request:URLRequest, completion:@escaping(_ data: Data?)->()) {
            let session = URLSession.shared.dataTask(with: request) { data, response, error in
                completion(data)
            }
            session.resume()
        }
    }
}
