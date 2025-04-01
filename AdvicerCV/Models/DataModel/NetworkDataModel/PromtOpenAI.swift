//
//  PromtOpenAI.swift
//  AdvicerCV
//
//  Created by Mykhailo Dovhyi on 31.03.2025.
//

import Foundation

enum PromtOpenAI:Codable {
    case advice(Advice)
    
    var promt:String {
        switch self {
        case .advice(let advice):
            let properties = PromtOpenAI.Advice.Keys.allCases.compactMap { key in
                "<\(key.identifier)>(\(key.valueDescription))</\(key.identifier)>"
            }.joined()
            return """
generate advice for iOS Developer CV, skills:\(advice.skills ?? ""), my top skills:SwiftUI,UIKit, optionaly with WatchKit but i like it, desireble job duties:iOS application development,in a cross plutform team. Structure advice response in keys: \(properties)
"""
            //generate request
            //choose cv button
            //job title
            //top skills
            //desireble job or job duties
            //
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
    struct Advice:Codable {
        let skills:String?
        
        enum Keys:String, CaseIterable, ResponseKeys {
            case cvCompletnessGrade
            case skillsGrade
            case skillImprovmentSuggestion
            case generalAdvice
            case skillContentCompletness
            var valueDescription: String {
                switch self {
                case .skillContentCompletness:
                    "Grade how clear i described skills section"
                case .generalAdvice:
                    "General advice"
                case .cvCompletnessGrade:
                    "grade cv content completness"
                case .skillsGrade:
                    "grade how skills are relevant for the position and years of experience"
                case .skillImprovmentSuggestion:
                    "suggest what skills I need to add"
                }
            }
            
            var identifier: String {
                self.rawValue
            }
        }
    }
    
    protocol ResponseKeys:CaseIterable {
        /// describes response for request
        var valueDescription:String { get }
        var identifier:String { get }
    }
}
