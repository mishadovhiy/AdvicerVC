//
//  NetworkModel.swift
//  AdvicerCV
//
//  Created by Mykhailo Dovhyi on 31.03.2025.
//

import Foundation

struct NetworkModel {
    func advice(_ input:PromtOpenAI.Advice, completion:@escaping(AdviceResponse?)->()) {
        guard let request = Request.openAIRequest(.advice(input)) else {
            completion(nil)
            return
        }
        PerformRequest.request(request) { data in
//            let dict = try? JSONSerialization.jsonObject(with: data ?? .init(), options: []) as? [String: Any]
            completion(.init(response: .init(data: data ?? .init(), encoding: .utf8) ?? ""))
        }
    }
}

