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
    
    
    struct CVContent:Codable {
        var workExperience:[WorkExperience] = []
        var skills:[Skill] = []
        var summary:String = ""
        var jobTitle:String = ""
        var contacts:[Contacts] = []
        struct Contacts:Codable {
            let contactTitle:String
            var contact:String
        }
        struct WorkExperience:Codable {
            var from:Date
            var to:Date? = nil
            var company:String = ""
            var summary:String = ""
            var skills:[String] = []
        }
        struct Skill:Codable {
            let name:String
            var description:String
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

extension GeneratorPDFViewModel {
    
    private func title(_ text:String) -> NSAttributedString {
        .init(string: "\(text)\n", attributes: [
            .link: URL(string: "action://title")!,//edit title font, color, text aligment
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
        let title:NSAttributedString = .init(string: "\(data.name)\n", attributes: [
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
    
    var attrubute:NSAttributedString {
        let mutable:NSMutableAttributedString = .init()
        mutable.append(title("Work Experience"))

        mutable.append(spacer)

        mutable.append(title("Summary"))
    
        return mutable
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
        .init(workExperience: .mock, skills: [.init(name: "skill 1", description: "some descr"), .init(name: "skill 2", description: "some descr")], summary: "some long text", jobTitle: "iOS Developer", contacts: [
            .init(contactTitle: "Email", contact: "hi@mishadovhiy.com")
        ])
    }
}
