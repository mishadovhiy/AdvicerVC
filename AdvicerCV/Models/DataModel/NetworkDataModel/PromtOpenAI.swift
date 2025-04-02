//
//  PromtOpenAI.swift
//  AdvicerCV
//
//  Created by Mykhailo Dovhyi on 31.03.2025.
//

import Foundation

enum PromtOpenAI:Codable {
    case advice(Advice)
    var advice:Advice? {
        switch self {
        case .advice(let advice):
            return advice
        }
    }
    var promt:String {
        switch self {
        case .advice(let advice):
            let properties = PromtOpenAI.Advice.Keys.allCases.compactMap { key in
                "<\(key.identifier)>(\(key.valueDescription))</\(key.identifier)>"
            }.joined()
            let values = advice.allValues.map { (key: Advice.RetriveTitles, value: String) in
                "\(key.rawValue.addSpaceBeforeCapitalizedLetters):\(value)"
            }.joined(separator: ",")
            return """
generate advice for iOS Developer CV, \(values), my top skills:SwiftUI,UIKit, optionaly with WatchKit but i like it, desireble job duties:iOS application development,in a cross plutform team. Structure advice response in keys: \(properties)
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
            ![advice.allValues].contains(where: {$0?.isEmpty ?? true})
        }
    }
}

extension PromtOpenAI {
    struct Advice:Codable {
        
        private var dict:[String:String] = [:]
        
        init(_ dict:[String:String]) {
            self.dict = dict
        }
        
        func text(for key:RetriveTitles) -> String {
            dict[key.rawValue] ?? ""
        }
        
        var allValues:[RetriveTitles:String] {
            var values:[RetriveTitles:String] = [:]
            RetriveTitles.allCases.forEach { key in
                values.updateValue(text(for: key), forKey: key)
            }
            return values
        }
        //discribes titles to retrive from cv
        enum RetriveTitles: String, CaseIterable {
            case skills
            case workingHistory
            case summary
            case education
            case contacts
            
            var alternative:[String] {
                switch self {
                case .workingHistory:["workHistory", "workExperience", "workingExperience"]
                case .contacts:["contactInformation"]
                default:
                    []
                }
            }
            
            var titles:[String] {
                var title = [rawValue]
                title.append(contentsOf: alternative)
                return title.compactMap({$0.addSpaceBeforeCapitalizedLetters.capitalized})
            }
        }
        
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
