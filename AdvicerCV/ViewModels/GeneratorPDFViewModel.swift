//
//  GeneratorPDFViewModel.swift
//  AdvicerCV
//
//  Created by Mykhailo Dovhyi on 02.04.2025.
//

import SwiftUI

struct GeneratorPDFViewModel {
    let model = PDFGeneratorModel()
    var exportingURL:URL? = nil
    var cvContent:CVContent = .init()
    var appearence:Appearence = .init()
    var linkSelected:(string:String, at:NSRange)?
    
    var isPresentingValueEditor:Bool {
        get {
            [editingWorkExperience].contains(where: {
                $0 != nil
            })
        }
        set {
            if !newValue {
                editingWorkExperience = nil
            }
        }
    }
    
    var editingWorkExperience:UUID? = nil
    
    mutating func exportPressed() {
        let data = model.generatePDF(from: .init(string: "some data"))
        exportingURL = model.savePDFDataToTempFile(data: data, fileName: "cv.pdf")
    }
    
    var isExportPresenting:Bool {
        get {
            exportingURL != nil
        }
        set {
            if !newValue {
                exportingURL = nil
            }
        }
    }
}

extension GeneratorPDFViewModel {
    
    var attrubute:NSAttributedString {
        let mutable:NSMutableAttributedString = .init()
        mutable.append(title("Summary"))
        mutable.append(summary)
        mutable.append(spacer)
        mutable.append(title("Work Experience"))
        mutable.append(spacer)
        mutable.append(workExperienceSections)
        mutable.append(spacer)
        mutable.append(title("Skills"))
        mutable.append(skills)
        mutable.append(spacer)
        return mutable
    }
    
    private func title(_ text:String) -> NSAttributedString {
        .init(string: "\(text)\n", attributes: [
            .link: URL(string: "action://\(text.replacingOccurrences(of: " ", with: ""))")!,
            .foregroundColor:appearence.toColor(.section)
        ])
    }
    
    private var spacer:NSAttributedString {
        let spacerAttachment = NSTextAttachment()
        spacerAttachment.bounds = CGRect(x: 0, y: 0, width: 0, height: 100)
        return NSAttributedString(attachment: spacerAttachment)
    }
    
    var workExperienceSections: NSAttributedString {
        let mutable:NSMutableAttributedString = .init()
        self.cvContent.workExperience.forEach { workExperience in
            mutable.append(self.workExperience(workExperience))
        }
        return mutable
    }
    
    func workExperience(_ item:CVContent.WorkExperience) -> NSAttributedString {
        let mutable:NSMutableAttributedString = .init()
        var companyName = item.company
        if companyName.isEmpty {
            companyName = "Enter company name"
        }
        let title:NSAttributedString = .init(string: "\(companyName)\n", attributes: [
            .foregroundColor:appearence.toColor(.section),
            .link: URL(string: "action://workExperience\(item.id.uuidString)")!,

        ])
        mutable.append(title)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .right
        paragraphStyle.paragraphSpacingBefore = -12
        let date:NSAttributedString = .init(string: "\(item.from.formatted(date: .complete, time: .standard)) ", attributes: [
            .foregroundColor:appearence.toColor(.section),
            .paragraphStyle:paragraphStyle,
        ])
        mutable.append(date)
        mutable.append(.init(string: "\n"))
        mutable.append(.init(string: item.summary + "\n", attributes: [
            .foregroundColor:appearence.toColor(.text),

        ]))
        return mutable
    }
    
    var skills: NSAttributedString {
        let mutable:NSMutableAttributedString = .init()
        self.cvContent.skills.forEach { skill in
            mutable.append(self.skill(skill))
        }
        return mutable
    }
    
    func skill(_ data:CVContent.Skill) -> NSAttributedString {
        let mutable:NSMutableAttributedString = .init()
        let title:NSAttributedString = .init(string: "\(data.name) ", attributes: [
            .link: URL(string: "action://title")!,//edit title font, color, text aligment
            .foregroundColor:appearence.toColor(.section)
        ])
        let description:NSAttributedString = .init(string: "\(data.description)\n", attributes: [
            .link: URL(string: "action://title")!,//edit title font, color, text aligment
            .foregroundColor:appearence.toColor(.section)
        ])
        mutable.append(title)
        mutable.append(description)
        return mutable
    }
    
    var summary: NSAttributedString {
        .init(string: cvContent.summary + "\n", attributes: [
            .foregroundColor:appearence.toColor(.text)
        ])
    }
}

extension [GeneratorPDFViewModel.CVContent.WorkExperience] {
    static var mock: [GeneratorPDFViewModel.CVContent.WorkExperience] {[
        .init(from: .init(), to: nil, company: "Some name", summary: "some long text", skills: ["skill"]),
        .init(from: Calendar.current.date(byAdding: .year, value: -1, to: .init())!, to: nil, company: "Some name 2", summary: "some long text", skills: ["skill"])
    ]}
}


extension GeneratorPDFViewModel.CVContent {
    static var mock:GeneratorPDFViewModel.CVContent {
        .init(workExperience: .mock, skills: [.init(name: "skill 1", description: "some descr"), .init(name: "skill 2", description: "some descr")], summary: """
Swift Developer with 4.5 years of commercial experience in iOS development. Created several projects
from scratch as a solo iOS Developer, in a cross-platform team, and in a team of iOS Developers. Have
created several pet projects for the AppStore (over 8 apps), including Video Editor, AI Meal Calendar
apps, Puzzle Game, and more with WidgetKit, WatchKit, RealityKit, CoreML, CoreGraphics, PDFKit
Proven track record in integrating APIs, deploying apps to the App Store, bugdixing. Ensuring clean and
reusable code that easily scales and readable for the team. Deep understanding in Memory management
and multithreading. Additionally, have 2 years of commercial experience in Front-End web development,
building REST API with NodeJS, PHP and MySQL database.
""", jobTitle: "iOS Developer", contacts: [
    .init(contactTitle: "Email", contact: "hi@mishadovhiy.com")
])
    }
}


extension GeneratorPDFViewModel {
    struct CVContent:Codable {
        var workExperience:[WorkExperience] = []
        var skills:[Skill] = []
        var summary:String = ""
        var jobTitle:String = ""
        var contacts:[Contacts] = []
        struct Contacts:Codable {
            let contactTitle:String
            var contact:String
            var id:UUID = .init()
        }
        struct WorkExperience:Codable {
            var from:Date
            var to:Date? = nil
            var company:String = ""
            var summary:String = ""
            var skills:[String] = []
            var id:UUID = .init()
        }
        struct Skill:Codable {
            let name:String
            var description:String
            var id:UUID = .init()
        }
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
