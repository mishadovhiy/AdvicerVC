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
    var linkSelected:String?
    
    mutating func linkSelected(_ link:String) {
        linkSelected = link
        if let key = GeneratorPDFViewModel.CVContent.Key.allCases.first(where: {
            link.lowercased().contains($0.rawValue.lowercased())
            
        }) {
            editingPropertyKey = key
            let id = link.lowercased().replacingOccurrences(of: key.rawValue.lowercased(), with: "")
            print(id, "ythrgtfd")
            if id.isEmpty {
                withAnimation {
                    self.editingWorkExperience = .init()
                    self.cvContent.workExperience.append(.init(from: .now, id: self.editingWorkExperience!))
                }
            } else {
                withAnimation {
                    self.editingWorkExperience = .init(uuidString: id)
                }
            }
        }
    }
    
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
    var editingPropertyKey:CVContent.Key? = nil

    private var editingValue:CVContent.ContentItem? {
        get {
            cvContent.dict[editingPropertyKey ?? .contacts]?.first(where: {
                $0.id == editingWorkExperience
            })
        }
        set {
            let dictionary = cvContent.dict[editingPropertyKey ?? .contacts] ?? []
            for i in 0..<dictionary.count {
                if dictionary[i].id == self.editingWorkExperience {
                    cvContent.dict[editingPropertyKey ?? .contacts]?[i] = newValue ?? .init()
                }
            }
        }
    }
    
    mutating func deleteSelectedItemPressed() {
        if let key = editingPropertyKey,
           let id = editingWorkExperience
        {
            var data = cvContent.dict[key] ?? []
            data.removeAll(where: {
                $0.id == self.editingWorkExperience
            })
            cvContent.dict.updateValue(data, forKey: key)
        }
        
        withAnimation {
            self.editingPropertyKey = nil
            self.editingWorkExperience = nil
        }
    }
    
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
        CVContent.Key.allCases.forEach { key in
            if let title = key.pdfTitle {
                mutable.append(self.title(title))
            }
            let value = self.cvContent.dict[key] ?? []
            mutable.append(spacer2)

            value.forEach { item in
                mutable.append(workExperience(item, key: key))
            }
            mutable.append(spacer)
        }
        mutable.removeAttribute(.underlineStyle, range: .init(location: 0, length: mutable.length))
        return mutable
    }
    
    private func title(_ text:String) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        return .init(string: "\(text)\n".uppercased(), attributes: [
            .link: URL(string: "action://\(text.replacingOccurrences(of: " ", with: ""))")!,
                .font:appearence.font[.section] ?? Appearence.FontData.default(.section).font,
            .foregroundColor:appearence.toColor(.section),
            .paragraphStyle:paragraphStyle
        ])
    }
    
    private var spacer:NSAttributedString {
//        let spacerAttachment = NSTextAttachment()
//        spacerAttachment.bounds = CGRect(x: 0, y: 0, width: 0, height: appearence.spaceBeforeSection)
//        return NSAttributedString(attachment: spacerAttachment)
        .init("\n\n")
    }
    
    private var spacer2:NSAttributedString {
//        let spacerAttachment = NSTextAttachment()
//        spacerAttachment.bounds = CGRect(x: 0, y: 0, width: 0, height: appearence.spaceBeforeText)
//        return NSAttributedString(attachment: spacerAttachment)
        .init(string: "\n", attributes: [
            .font:UIFont.systemFont(ofSize: 5)
        ])

    }
    
    func workExperience(_ item:CVContent.ContentItem, key:CVContent.Key) -> NSAttributedString {
        let mutable:NSMutableAttributedString = .init()
        var companyName = item.title
        if companyName.isEmpty {
            companyName = key.pdfPreviewTitlePlaceholder
        }
        let title:NSAttributedString = .init(string: companyName, attributes: [
            .foregroundColor:appearence.toColor(.title),
            .font:appearence.font[.title] ?? Appearence.FontData.default(.title).font,
            .link: URL(string: "action://\(key.rawValue)\(item.id.uuidString)")!,

        ])
        mutable.append(title)
        
        mutable.append(.init(string: "\n"))
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .right
        paragraphStyle.paragraphSpacingBefore = -12
        let date:NSAttributedString = .init(string: "\(item.from?.formatted(date: .complete, time: .standard) ?? "") ", attributes: [
            .font:appearence.font[.title] ?? Appearence.FontData.default(.title).font,
            .foregroundColor:appearence.toColor(.title),
            .paragraphStyle:paragraphStyle,
        ])
        mutable.append(date)
        mutable.append(.init(string: "\n"))
        if !item.titleDesctiption.isEmpty {
            let description:NSAttributedString = .init(string: " " + item.titleDesctiption, attributes: [
                .foregroundColor:appearence.toColor(.smallDescription),
                .font:appearence.font[.smallDescription] ?? Appearence.FontData.default(.smallDescription).font,

            ])
            mutable.append(description)
            mutable.append(.init(string: "\n"))
        }
        mutable.append(.init(string: item.text + "\n", attributes: [
            .foregroundColor:appearence.toColor(.text),
            .font:appearence.font[.text] ?? Appearence.FontData.default(.text).font,

        ]))
        return mutable
    }
}

extension GeneratorPDFViewModel {
    var editingPropertyDateFrom:Date {
        get {
            editingValue?.from ?? .init()
        }
        set {
            editingValue?.from = newValue
        }
    }
    
    var editingPropertyDateTo:Date {
        get {
            editingValue?.to ?? .init()
        }
        set {
            editingValue?.to = newValue
        }
    }
    
    
    var editingNeedLeftSpace:Bool {
        get {
            editingValue?.needLeftSpace ?? false
        }
        set {
            editingValue?.needLeftSpace = newValue
        }
    }
    var editingPropertyTitleDescription:String {
        get {
            editingValue?.titleDesctiption ?? ""
        }
        set {
            editingValue?.titleDesctiption = newValue
        }
    }
    
    var editingPropertyTitle:String {
        get {
            editingValue?.title ?? ""
        }
        set {
            editingValue?.title = newValue
        }
    }
    
    var editingPropertyText:String {
        get {
            editingValue?.text ?? ""
        }
        set {
            editingValue?.text = newValue
        }
    }
}
