//
//  CVContent.swift
//  AdvicerCV
//
//  Created by Mykhailo Dovhyi on 05.04.2025.
//

import SwiftUI

extension GeneratorPDFViewModel {
    struct CVContent:Codable {
        typealias Key = PromtOpenAI.Advice.RetriveTitles
        var workExperience:[WorkExperience] {
            get {
                data[Key.workingHistory.rawValue] ?? []
            }
            set {
                data.updateValue(newValue, forKey: Key.workingHistory.rawValue)
            }
        }
        var skills:[WorkExperience] {
            get {
                data[Key.skills.rawValue] ?? []
            }
            set {
                data.updateValue(newValue, forKey: Key.skills.rawValue)
            }
        }
        var summary:[WorkExperience] {
            get {
                data[Key.summary.rawValue] ?? []
            }
            set {
                data.updateValue(newValue, forKey: Key.summary.rawValue)
            }
        }
        var jobTitle:[WorkExperience] {
            get {
                data[Key.jobTitle.rawValue] ?? []
            }
            set {
                data.updateValue(newValue, forKey: Key.jobTitle.rawValue)
            }
        }
        var titleDescription:[WorkExperience] {
            get {
                data[Key.jobTitleDescription.rawValue] ?? []
            }
            set {
                data.updateValue(newValue, forKey: Key.jobTitleDescription.rawValue)
            }
        }
        var contacts:[WorkExperience] {
            get {
                data[Key.contacts.rawValue] ?? []
            }
            set {
                data.updateValue(newValue, forKey: Key.contacts.rawValue)
            }
        }
        var education:[WorkExperience] {
            get {
                data[Key.education.rawValue] ?? []
            }
            set {
                data.updateValue(newValue, forKey: Key.education.rawValue)
            }
        }
        var portfolio:[WorkExperience] {
            get {
                data[Key.portfolio.rawValue] ?? []
            }
            set {
                data.updateValue(newValue, forKey: Key.portfolio.rawValue)
            }
        }
        
        init(workExperience:[WorkExperience] = [],
             skills:[WorkExperience] = [],
             summary:[WorkExperience] = [],
             jobTitle:[WorkExperience] = [],
             titleDescription:[WorkExperience] = [],
             contacts:[WorkExperience] = [],
             education:[WorkExperience] = [],
             portfolio:[WorkExperience] = []) {
            self.init([
                .workingHistory:workExperience,
                .skills:skills,
                .summary:summary,
                .jobTitle:jobTitle,
                .jobTitleDescription:titleDescription,
                .contacts:contacts,
                .education:education,
                .portfolio:portfolio
            ])
        }
        
        private var data:[String:[WorkExperience]] = [:]

        var dict:[Key:[WorkExperience]] {
            get {
                let dict = self.data.map { (key: String, value: [WorkExperience]) in
                    (Key(rawValue: key) ?? .contacts, value)
                }
                return Dictionary(uniqueKeysWithValues: dict)
            }
            set {
                let array = newValue.map { (key: Key, value: [WorkExperience]) in
                    (key.rawValue, value)
                }
                self.data = Dictionary(uniqueKeysWithValues: array)
            }
        }
        
        init(_ data:[PromtOpenAI.Advice.RetriveTitles:[WorkExperience]] = [:]) {
            data.forEach { (key: PromtOpenAI.Advice.RetriveTitles, value: [WorkExperience]) in
                self.data.updateValue(value, forKey: key.rawValue)
            }
        }
        
        
        
        struct WorkExperience:Codable {
                    var from:Date? = nil
                    var to:Date? = nil
                    var title:String = ""
                    var titleDesctiption:String = ""
                    var text:String = ""
                    var bottomList:[String] = []
                    var id:UUID = .init()
                }
//        struct Skill:Codable {
//            let name:String
//            var description:String
//            var id:UUID = .init()
//        }
    }
    struct Appearence:Codable {
        var color:[ContentType:String] = [:]
        func toColor(_ key:ContentType) -> UIColor {
            .init(hex: color[key] ?? "") ?? .white
        }
        var spaceBeforeSection:CGFloat = 15
        var spaceBeforeText:CGFloat =  5
        
    }
    enum ContentType:String, Codable {
        case separetor, background
        case title, description, section, smallDescription //(displeys at right)
        case text
    }
}
