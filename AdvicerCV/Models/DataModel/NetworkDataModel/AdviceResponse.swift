//
//  AdviceResponse.swift
//  AdvicerCV
//
//  Created by Mykhailo Dovhyi on 01.04.2025.
//

import Foundation

struct AdviceResponse:Codable {
    private var dict:[String:String] = [:]
    func value(for key:PromtOpenAI.Advice.Keys) -> String {
        dict[key.rawValue] ?? ""
    }
    
    init(data: [String : String]) {
        self.dict = data
    }
    
    init(response:String) {
        PromtOpenAI.Advice.Keys.allCases.forEach { key in
            dict.updateValue(response.extractSubstring(key: key.rawValue) ?? "", forKey: key.rawValue)
        }
    }
}
