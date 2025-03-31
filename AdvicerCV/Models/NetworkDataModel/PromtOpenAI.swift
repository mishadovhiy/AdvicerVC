//
//  PromtOpenAI.swift
//  AdvicerCV
//
//  Created by Mykhailo Dovhyi on 31.03.2025.
//

import Foundation

enum PromtOpenAI {
    case advice(Advice)
    
    var promt:String {
        switch self {
        case .advice(let advice):
            //what to improve (skills, what skills to add), formating(is skills formating is ok or can be improved)
            //
            return """
generate advice for iOS Developer CV, skills:\(advice.skills ?? "")
"""
        }
    }
    var isValid:Bool {
        switch self {
        case .advice(let advice):
            ![advice.skills].contains(where: {$0?.isEmpty ?? true})
        }
    }
}

extension PromtOpenAI {
    struct Advice {
        let skills:String?
    }
}
