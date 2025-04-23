//
//  PromtOpenAI.swift
//  AdvicerCV
//
//  Created by Mykhailo Dovhyi on 31.03.2025.
//

import Foundation

enum NetworkRequest:Codable {
    case support(SupportRequest)
    case advice(Advice)
    case fetchHTML(FetchHTMLRequest)

    var advice:Advice? {
        switch self {
        case .advice(let advice):
            return advice
        default:return nil
        }
    }
    var promt:String {
        switch self {
        case .fetchHTML:
            return ""
        case .advice(let advice):
            let properties = NetworkRequest.Advice.Keys.allCases.compactMap { key in
                "<\(key.identifier)>(\(key.valueDescription))</\(key.identifier)>"
            }.joined()
            
            let values = advice.allValues.filter({ dict in
                dict.key.openAIUsed
            })
                let res = values.map { (key: Advice.RetriveTitles, value: String) in
                "\(key.rawValue.addSpaceBeforeCapitalizedLetters):\(value)"
            }.joined(separator: ",")
            return """
generate advice for iOS Developer CV, \(res), my top skills:SwiftUI,UIKit, optionaly with WatchKit but i like it, desireble job duties:iOS application development,in a cross plutform team. Structure advice response in keys: \(properties). All Grades should be from 1 to 5
"""
            //generate request
            //choose cv button
            //job title
            //top skills
            //desireble job or job duties
            //
        default:return ""
        }
    }
    var isValid:Bool {
        switch self {
        case .advice(let advice):
            ![advice.allValues].contains(where: {$0?.isEmpty ?? true})
        default:true
        }
    }
}

extension NetworkRequest {
    struct SupportRequest:Codable {
        var text:String = ""
        var header:String = ""
        var title:String = ""
    }
    
    struct FetchHTMLRequest:Codable {
        var url:String
    }
    
    struct Advice:Codable {
        
        var dict:[String:String] = [:]
        
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
//            values.forEach { (key: RetriveTitles, value: String) in
//                values.forEach { (key1: RetriveTitles, value1: String) in
//                    if key != key1 {
//                        values[key] = values[key]?.replacingOccurrences(of: values[key1] ?? "", with: "")
//                    }
//                }
//            }
            return values
        }
        //discribes titles to retrive from cv
        enum RetriveTitles: String, CaseIterable {
            case jobTitle
            case cvDescriptionTitle
            case summary
            case skills
            case portfolio
            case workingHistory
            case education
            case contacts
            
            var needDates:Bool {
                switch self {
                case .workingHistory, .education:true
                default:false
                }
            }
            
            var pdfPreviewTitlePlaceholder:String {
                switch self {
                case .skills:
                    "Enter skill name"
                case .workingHistory:
                    "Enter company name"
                case .summary:
                    ""
                case .education:
                    "Enter univertsity name"
                case .contacts:
                    "Enter contact type"
                case .portfolio:
                    "Enter project name"
                case .jobTitle:
                    "Enter job title"
                case .cvDescriptionTitle:
                    "Enter CV Description"
                }
            }
            
            var openAIUsed:Bool {
                switch self {
                case .portfolio, .contacts, .jobTitle, .cvDescriptionTitle:false
                default:true
                }
            }
            var alternative:[String] {
                switch self {
                case .workingHistory:["workHistory", "workExperience", "workingExperience"]
                case .contacts:["contactInformation", "CONTACT INFORMATION", "CONTACTINFORMATION"]
                default:
                    []
                }
            }
            
            var titles:[String] {
                var title = [rawValue]
                title.append(contentsOf: alternative)
                return title.compactMap({$0.addSpaceBeforeCapitalizedLetters.capitalized})
            }
            
            private var needPDFTitle:Bool {
                switch self {
                case .jobTitle, .cvDescriptionTitle:false
                default:true
                }
            }
            
            var pdfTitle:String? {
                if needPDFTitle {
                    return titles.first ?? ""
                } else {
                    return nil
                }
            }
            
            var pdfTextInline:Bool {
                switch self {
                case .skills, .portfolio, .contacts:true
                default:false
                }
            }
        }
        
        enum Keys:String, CaseIterable, ResponseKeys {
            case cvCompletnessGrade
            case skillsGrade
            case skillImprovmentSuggestion
            case generalAdvice
            case skillContentCompletness
            case atsGrade
            case employmentDurationGrade
            case cvImprovment
            
            var valueDescription: String {
                switch self {
                case .employmentDurationGrade:
                    "Grade employment duration"
                case .atsGrade:
                    "Grade how CV is ATS friendly"
                case .skillContentCompletness:
                    "Grade how clear i described skills section"
                case .generalAdvice:
                    "General advice"
                case .cvCompletnessGrade:
                    "grade cv content completness"
                case .skillsGrade:
                    "grade how skills are relevant for the position and years of experience"
                case .skillImprovmentSuggestion:
                    "suggest what skills I need to add if any"
                case .cvImprovment:
                    "suggest what can i improve in my CV"
                }
            }
            
            var identifier: String {
                self.rawValue
            }
            
            var title:String {
                rawValue.addSpaceBeforeCapitalizedLetters.capitalized
            }
        }
    }
    
    protocol ResponseKeys:CaseIterable {
        /// describes response for request
        var valueDescription:String { get }
        var identifier:String { get }
    }
}
