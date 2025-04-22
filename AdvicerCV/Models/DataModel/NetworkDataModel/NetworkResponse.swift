//
//  AdviceResponse.swift
//  AdvicerCV
//
//  Created by Mykhailo Dovhyi on 01.04.2025.
//

import Foundation

struct NetworkResponse {
    struct AdviceResponse:Codable {
        private var dict:[String:String] = [:]
        func value(for key:NetworkRequest.Advice.Keys) -> String {
            dict[key.rawValue] ?? ""
        }
        
        mutating func setValue(for key:NetworkRequest.Advice.Keys, newValue:String) {
            dict.updateValue(newValue, forKey: key.rawValue)
        }
        var date:Date = .init()
        init(data: [String : String]) {
            self.dict = data
        }
        
        init(response:String) {
            NetworkRequest.Advice.Keys.allCases.forEach { key in
                dict.updateValue(response.extractSubstring(key: key.rawValue) ?? "", forKey: key.rawValue)
            }
            print(dict, " ygtefrdws")
        }
    }
    
    struct SupportResponse: Codable {
        private let data:Data?
        private var ok:String {
            NSString(data: data ?? .init(), encoding: String.Encoding.utf8.rawValue)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        }
        init(data: Data?) {
            self.data = data
        }
        var success:Bool {
            return ok == "1"
        }
    }
}
