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
generate advice for \(advice.allValues[.jobTitle] ?? "unknown job title") CV, content: \(res). Structure advice response in keys: \(properties). All Grades should be from 1 to 5
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
            var needDescription:Bool {
                switch self {
                case .jobTitle, .cvDescriptionTitle, .skills:false
                default: true
                }
            }
            
            var canDelete:Bool {
                switch self {
                case .summary, .jobTitle, .cvDescriptionTitle:false
                default: true
                }
            }
            
            var needLargeText:Bool {
                switch self {
                case .jobTitle, .cvDescriptionTitle:false
                default: true
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
        
        /// Declared Keys for OpenAI request, each key rawValue and decription sent in OpenAI's prompt in the request
        enum Keys:String, CaseIterable, ResponseKeys {
            case cvCompletnessGrade
            case skillsGrade
            case skillImprovmentSuggestion
            case skillContentCompletnessGrade
            case skillGroupingMistakes
            case skillGropingSuggestions
            case advancedSkillImproveSuggestions
            case atsGrade
            case employmentDurationGrade
            case employmentDescriptionSuggestions
            case contentDescriptionsMistakes
            case advancedContentImprovingSuggestions
            case cvImprovment
            case generalAdvice
            

            /// value description for OpenAI request
            var valueDescription: String {
                switch self {
                case .skillGropingSuggestions:
                    "Describe if i can regroup skills"
                case .skillGroupingMistakes:
                    "Describe if there any mistake grouping my skills"
                case .contentDescriptionsMistakes:
                    "Describe if there any mistakes in my content, such as logical, grammar"
                case .advancedContentImprovingSuggestions:
                    "Advanced content fillness improving"
                case .advancedSkillImproveSuggestions:
                    "Suggestions for advanced improving my skills"
                case .employmentDurationGrade:
                    "Grade employment duration"
                case .employmentDescriptionSuggestions:
                    "Suggest what can i improve in working history section description"
                case .atsGrade:
                    "Grade how CV is ATS friendly"
                case .skillContentCompletnessGrade:
                    "Grade how clear i described skills section"
                case .generalAdvice:
                    "General advice"
                case .cvCompletnessGrade:
                    "Grade cv content completness"
                case .skillsGrade:
                    "Grade how skills are relevant for the position and years of experience"
                case .skillImprovmentSuggestion:
                    "Suggest what skills I need to add if any"
                case .cvImprovment:
                    "Suggest what can i improve in my CV"
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
