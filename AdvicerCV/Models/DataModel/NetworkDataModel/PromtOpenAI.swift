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
            case atsGrade
            var valueDescription: String {
                switch self {
                case .atsGrade:
                    "Grde how CV is ATS friendly"
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

//not refactored
extension PromtOpenAI.Advice {
    struct WorkExperience {
        var companyName: String
        var position: String
        var startDate: String
        var endDate: String
        var skills: [String]
        var duration: String
    }
    func extractDates(from text: String) -> (startDate: String?, endDate: String?) {
        // Regular expression to match various date formats
        let regexPattern = "(\\b[A-Za-z]{3}\\s\\d{4}\\b|\\b\\d{4}\\b|\\b[A-Za-z]{3}\\s\\d{4}\\s[-–to]+\\s[A-Za-z]{3}\\s\\d{4}\\b|Present)"
        
        let regex = try? NSRegularExpression(pattern: regexPattern, options: .caseInsensitive)
        let nsRange = NSRange(text.startIndex..., in: text)
        
        if let matches = regex?.matches(in: text, options: [], range: nsRange) {
            var startDate: String?
            var endDate: String?
            
            for match in matches {
                let matchedString = (text as NSString).substring(with: match.range)
                
                if matchedString.contains("-") || matchedString.contains("to") {
                    let dateParts = matchedString.split { $0 == "-" || $0 == " " || $0 == "t" }.map { $0.trimmingCharacters(in: .whitespaces) }
                    
                    if dateParts.count == 2 {
                        startDate = dateParts[0]
                        endDate = dateParts[1]
                    }
                }
                
                else if matchedString.contains("Present") {
                    startDate = matchedString.replacingOccurrences(of: " Present", with: "").trimmingCharacters(in: .whitespaces)
                    endDate = "Present"
                } else if matchedString.count == 7, let _ = matchedString.range(of: " ") {
                    startDate = matchedString
                }
            }
            
            return (startDate, endDate)
        }
        
        return (nil, nil)
    }

    func extractWorkExperience(from text: String) -> [WorkExperience] {
        var experiences: [WorkExperience] = []
        

        let dateFormats = [
            "MMM yyyy",
            "yyyy-MM",
            "MMM yyyy – MMM yyyy",
            "yyyy to yyyy",
            "MMM yyyy – Present",
            "yyyy",
            "yyyy-MM-dd",
            "MMM dd, yyyy", // Example: Jan 01, 2020
            "dd MMM yyyy" // Example: 01 Jan 2020
        ]
        
        let lines = text.split(separator: "\n")
        
        var currentCompany: String?
        var currentPosition: String?
        var currentStartDate: String?
        var currentEndDate: String?
        var currentSkills: [String] = []
        
        for line in lines {
            let lineStr = String(line)
            
            // Match the company and position lines
            if lineStr.contains("–") {
                let components = lineStr.split(separator: "–")
                if components.count > 1 {
                    currentCompany = String(components[0]).trimmingCharacters(in: .whitespaces)
                    currentPosition = String(components[1]).trimmingCharacters(in: .whitespaces)
                    print(currentPosition, " rgvefd ", self.extractDates(from: currentPosition ?? ""))

                }
            }
            
            // Capture start and end dates, if they exist
            if lineStr.contains("–") && lineStr.contains("PRESENT") == false {
                let dateParts = lineStr.split(separator: "-")
                if dateParts.count > 1 {
                    currentStartDate = String(dateParts[0]).trimmingCharacters(in: .whitespaces)
                    currentEndDate = String(dateParts[1]).trimmingCharacters(in: .whitespaces)
                    print(currentStartDate, " efrwddef")
                }
            } else if lineStr.contains("PRESENT") {
                currentEndDate = "Present"
            }
   
            
            // When we've captured the full experience block, create an entry
            if lineStr.isEmpty {
                if let company = currentCompany, let position = currentPosition,
                   let startDate = currentStartDate, let endDate = currentEndDate {
                    let duration = calculateExperienceDuration(startDate: startDate, endDate: endDate)
                    let workExperience = WorkExperience(
                        companyName: company,
                        position: position,
                        startDate: startDate,
                        endDate: endDate,
                        skills: currentSkills,
                        duration: duration
                    )
                    experiences.append(workExperience)
                    // Reset for the next block
                    currentCompany = nil
                    currentPosition = nil
                    currentStartDate = nil
                    currentEndDate = nil
                    currentSkills.removeAll()
                }
            }
        }
        return experiences
    }

    // Function to calculate the duration between start and end dates
    func calculateExperienceDuration(startDate: String, endDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy" // Format like Jan 2020 or Mar 2021
        
        var startDateObj: Date?
        var endDateObj: Date?
        
        if let start = dateFormatter.date(from: startDate) {
            startDateObj = start
        }
        
        if endDate.lowercased() == "present" {
            endDateObj = Date() // Use current date if the end date is "Present"
        } else if let end = dateFormatter.date(from: endDate) {
            endDateObj = end
        }
        
        guard let start = startDateObj, let end = endDateObj else {
            return "Invalid Date Format"
        }
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: start, to: end)
        
        return "\(components.year ?? 0) years, \(components.month ?? 0) months"
    }
}

extension [PromtOpenAI.Advice.WorkExperience] {
    var years:String {
        self.compactMap { item in
            "\(item.startDate)-\(item.endDate)"
        }.joined(separator: ", ")
    }
}
