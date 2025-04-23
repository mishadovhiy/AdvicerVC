//
//  String.swift
//  AdvicerCV
//
//  Created by Mykhailo Dovhyi on 31.03.2025.
//

import Foundation

extension String {
    var dates:(Date?, Date?)? {
        let regexPattern = "(\\b[A-Za-z]{3})\\s(\\d{4})\\s–\\s([A-Za-z]{3})\\s(\\d{4})\\b"

        let regex = try! NSRegularExpression(pattern: regexPattern, options: [])

        let range = NSRange(location: 0, length: self.utf16.count)
        if let match = regex.firstMatch(in: self, options: [], range: range) {
            let startMonthString = (self as NSString).substring(with: match.range(at: 1))
            let startYearString = (self as NSString).substring(with: match.range(at: 2))
            let endMonthString = (self as NSString).substring(with: match.range(at: 3))
            let endYearString = (self as NSString).substring(with: match.range(at: 4))
            
            let startDateString = "\(startMonthString) \(startYearString)"
            let endDateString = "\(endMonthString) \(endYearString)"
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM yyyy"
            
            let startDate = dateFormatter.date(from: startDateString)
            let endDate = dateFormatter.date(from: endDateString)
            return (startDate, endDate)
        } else {
            print("No date range found in the string.")
            return nil
        }
    }
    
    var addSpaceBeforeCapitalizedLetters: String {
        let regex = try? NSRegularExpression(pattern: "(?<=\\w)(?=[A-Z])", options: [])
        let result = regex?.stringByReplacingMatches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count), withTemplate: " $0")
        return result ?? self
    }
    
    func extractSubstring(key:String, key2:String) -> String? {
        let pattern = "<\(key)>(.*?)<\(key2)>"
        guard let regex = try? NSRegularExpression(pattern: pattern, options: [.dotMatchesLineSeparators]) else {
            
                return nil
            }
            
            let range = NSRange(self.startIndex..<self.endIndex, in: self)
        if let match = regex.firstMatch(in: self, options: [], range: range) {
                
                let rangeStart = match.range(at: 1)
                if let swiftRange = Range(rangeStart, in: self) {
                    return String(self[swiftRange])
                }
            }
        
        return nil
    }

    
    func extractSubstring(key:String) -> String? {
        let pattern = "<\(key)>(.*?)</\(key)>"
        guard let regex = try? NSRegularExpression(pattern: pattern, options: [.dotMatchesLineSeparators]) else {
            
                return nil
            }
            
            let range = NSRange(self.startIndex..<self.endIndex, in: self)
        if let match = regex.firstMatch(in: self, options: [], range: range) {
                
                let rangeStart = match.range(at: 1)
                if let swiftRange = Range(rangeStart, in: self) {
                    return String(self[swiftRange])
                }
            }
        
        return nil
    }
    
    func extractXML(key1:String, key2:String) -> [String:String] {
        let pattern = "<\(key1)>(.*?)</\(key1)>\\s*<\(key2)>(\\d+)</\(key2)>"
        let xmlString = self
        if let regex = try? NSRegularExpression(pattern: pattern, options: [.dotMatchesLineSeparators]) {
            let matches = regex.matches(in: xmlString, range: NSRange(xmlString.startIndex..., in: xmlString))
            
            var result: [String: String] = [:]
            
            for match in matches {
                if let range1 = Range(match.range(at: 1), in: xmlString),
                   let range2 = Range(match.range(at: 2), in: xmlString) {
                    let ingredient = String(xmlString[range1])
                    let calories = String(xmlString[range2])
                    result[ingredient] = calories
                }
            }
            
            return result
        } else {
            return [:]
        }
    }
}
