//
//  NetworkModel.swift
//  AdvicerCV
//
//  Created by Mykhailo Dovhyi on 31.03.2025.
//

import Foundation

struct NetworkModel {
    func advice(_ input:NetworkRequest.Advice, completion:@escaping(NetworkResponse.AdviceResponse?)->()) {
        Request(.advice(input)).perform() { data in
//            let dict = try? JSONSerialization.jsonObject(with: data ?? .init(), options: []) as? [String: Any]
            completion(.init(response: .init(data: data ?? .init(), encoding: .utf8) ?? ""))
        }
    }
    
    func support(_ input:NetworkRequest.SupportRequest, completion:@escaping(NetworkResponse.SupportResponse?)->()) {
        Request.init(.support(input)).perform(data: "44fdcv8jf3") { data in
//            let dict = try? JSONSerialization.jsonObject(with: data ?? .init(), options: []) as? [String: Any]
            completion(.init(data: data))
        }
    }
    
    func fetchHTM(_ input:NetworkRequest.FetchHTMLRequest, completion:@escaping(_ response:NetworkResponse.FetchHTMLResponse)->()) {
        Request(.fetchHTML(input)).perform { data in
            completion(.init(data: data))
        }
    }
}

