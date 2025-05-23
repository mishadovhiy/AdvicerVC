//
//  CVContent.swift
//  AdvicerCV
//
//  Created by Mykhailo Dovhyi on 05.04.2025.
//

import SwiftUI

extension GeneratorPDFViewModel {
    struct CVContent:Codable {
        typealias Key = NetworkRequest.Advice.RetriveTitles
        var order:[String:Int] = [:]
        var workExperience:[ContentItem] {
            get {
                data[Key.workingHistory.rawValue] ?? []
            }
            set {
                data.updateValue(newValue, forKey: Key.workingHistory.rawValue)
            }
        }
        var skills:[ContentItem] {
            get {
                data[Key.skills.rawValue] ?? []
            }
            set {
                data.updateValue(newValue, forKey: Key.skills.rawValue)
            }
        }
        var summary:[ContentItem] {
            get {
                data[Key.summary.rawValue] ?? []
            }
            set {
                data.updateValue(newValue, forKey: Key.summary.rawValue)
            }
        }
        var jobTitle:[ContentItem] {
            get {
                data[Key.jobTitle.rawValue] ?? []
            }
            set {
                data.updateValue(newValue, forKey: Key.jobTitle.rawValue)
            }
        }
        var titleDescription:[ContentItem] {
            get {
                data[Key.cvDescriptionTitle.rawValue] ?? []
            }
            set {
                data.updateValue(newValue, forKey: Key.cvDescriptionTitle.rawValue)
            }
        }
        var contacts:[ContentItem] {
            get {
                data[Key.contacts.rawValue] ?? []
            }
            set {
                data.updateValue(newValue, forKey: Key.contacts.rawValue)
            }
        }
        var education:[ContentItem] {
            get {
                data[Key.education.rawValue] ?? []
            }
            set {
                data.updateValue(newValue, forKey: Key.education.rawValue)
            }
        }
        var portfolio:[ContentItem] {
            get {
                data[Key.portfolio.rawValue] ?? []
            }
            set {
                data.updateValue(newValue, forKey: Key.portfolio.rawValue)
            }
        }
        
        init(advice:NetworkRequest.Advice) {
            advice.allValues.forEach { (key: NetworkRequest.Advice.RetriveTitles, value: String) in
                if !key.needLargeText {
                    self.data.updateValue([.init(title:value)], forKey: key.rawValue)
                } else {
                    self.data.updateValue([.init(text:value)], forKey: key.rawValue)
                }
            }
        }
        
        init(workExperience:[ContentItem] = [],
             skills:[ContentItem] = [],
             summary:[ContentItem] = [],
             jobTitle:[ContentItem] = [],
             titleDescription:[ContentItem] = [],
             contacts:[ContentItem] = [],
             education:[ContentItem] = [],
             portfolio:[ContentItem] = []) {
            self.init([
                .workingHistory:workExperience,
                .skills:skills,
                .summary:summary,
                .jobTitle:jobTitle,
                .cvDescriptionTitle:titleDescription,
                .contacts:contacts,
                .education:education,
                .portfolio:portfolio
            ])
        }
        
        private var data:[String:[ContentItem]] = [:]
        
        var dict:[Key:[ContentItem]] {
            get {
                let dict = self.data.map { (key, value) in
                    (Key(rawValue: key) ?? .contacts, value)
                }
                return Dictionary(uniqueKeysWithValues: dict)
            }
            set {
                let array = newValue.map { (key, value) in
                    (key.rawValue, value)
                }
                self.data = Dictionary(uniqueKeysWithValues: array)
            }
        }
        
        init(_ data:[NetworkRequest.Advice.RetriveTitles:[ContentItem]] = [:]) {
            data.forEach { (key: NetworkRequest.Advice.RetriveTitles, value: [ContentItem]) in
                self.data.updateValue(value, forKey: key.rawValue)
            }
        }
        
        struct ContentItem:Codable {
            var from:Date? = nil
            var to:Date? = nil
            var title:String = ""
            var titleDesctiption:String = ""
            var text:String = ""
            var bottomList:[String] = []
            var needLeftSpace:Bool = false
            var boldTexts:String = ""
            var id:UUID = .init()
        }
    }
    struct Appearence:Codable {
        var color:[ContentType:String] = [:]
        func toColor(_ key:ContentType) -> UIColor {
            .init(hex: color[key] ?? "") ?? key.defaultColor
        }
        var spaceBeforeSection:CGFloat = 15
        var spaceBeforeText:CGFloat =  5
        var font:[ContentType:FontData] = [:]
        struct FontData:Codable {
            var size:CGFloat = 10
            private var weight:Int = 500
            
            var font:UIFont {
                .systemFont(ofSize: size, weight: fontWeight)
            }
            
            static func `default`(_ type:ContentType) -> FontData {
                switch type {
                case .cvTitle: .init(size: 28, weight: 700)
                case .separetor, .background:
                        .init()
                case .title:
                        .init(size: 10, weight: 700)

                case .description:
                        .init()
                case .section:
                        .init(size: 10, weight: 700)
                case .smallDescription:
                        .init(size: 9)
                case .text:
                        .init()
                }
            }
            
            var fontWeight:UIFont.Weight {
                get {
                    switch self.weight {
                    case 400:.light
                    case 500:.regular
                    case 600:.semibold
                    case 700:.bold
                    default:.regular
                    }
                }
                set {
                    var weight:Int {
                        switch newValue {
                        case .light:400
                        case .regular:500
                        case .semibold:600
                        case .bold:700
                        default:500
                        }
                    }
                    self.weight = weight
                }
            }
            
        }
    }
    enum ContentType:String, CaseIterable, Codable {
        case separetor, background
        case title, description, section, smallDescription //(displeys at right)
        case text
        case cvTitle
        
        var canSetFont:Bool {
            switch self {
            case .separetor, .background:false
            default:true
            }
        }
        
        var title:String {
            rawValue.addSpaceBeforeCapitalizedLetters.capitalized
        }
        
        var defaultColor:UIColor {
            switch self {
            case .separetor:
                    .pdfText.withAlphaComponent(0.1)
            case .background:
                    .white
            case .title:
                    .pdfText
            case .description:
                    .pdfText
            case .section, .cvTitle:
                    .sectionTitle
            case .smallDescription:
                    .pdfText
            case .text:
                    .pdfText
            }
        }
    }
}
