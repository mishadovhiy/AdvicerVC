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
    var colorSelectingFor:ContentType?
    var fontSelectingFor:ContentType?
    var selectingDateFrom:Bool = false
    var selectingDateTo: Bool = false
    var generalColorsPresenting = false
    var generalFontsPresenting = false
    var generalSpacesPresenting = false
    var editorNavigationPushed:Bool {
        [generalColorsPresenting, generalFontsPresenting].contains(true)
    }
    
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
                    switch key {
                    case .workingHistory:
                        self.cvContent.workExperience.append(.init(from: .now, id: self.editingWorkExperience!))
                    case .contacts:
                        self.cvContent.contacts.append(.init(from: .now, id: self.editingWorkExperience!))
                    case .education:
                        self.cvContent.education.append(.init(from: .now, id: self.editingWorkExperience!))
                    case .portfolio:
                        self.cvContent.portfolio.append(.init(from: .now, id: self.editingWorkExperience!))
                    case .skills:
                        self.cvContent.skills.append(.init(from: .now, id: self.editingWorkExperience!))
                    case .summary:
                        self.editingWorkExperience = cvContent.summary.first?.id
                    case .jobTitle:
                        self.editingWorkExperience = cvContent.jobTitle.first?.id
                    case .cvDescriptionTitle:
                        self.editingWorkExperience = cvContent.titleDescription.first?.id

                    }
                }
            } else {
                withAnimation {
                    self.editingWorkExperience = .init(uuidString: id)
                }
            }
        }
    }
    
    var largeEditorHeight:Bool {
        [isPresentingValueEditor, colorSelectingFor != nil, fontSelectingFor != nil].contains(true)
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
    
    
    var exportPDFPressed = false
    mutating func exportPressed() {
        exportPDFPressed = true
        let data = model.generatePDF(from: attrubute)
        exportingURL = model.savePDFDataToTempFile(data: data, fileName: "cv.pdf")
        exportPDFPressed = false
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
            let needSpaces = !key.rawValue.lowercased().contains("title")
            if needSpaces {
                mutable.append(spacer)
            }

            if let title = key.pdfTitle {
                mutable.append(self.title(title))
            }
            let value = self.cvContent.dict[key] ?? []
            if needSpaces {
                mutable.append(separetor)
                mutable.append(spacer2)
                mutable.append(spacer2)
            }


            value.forEach { item in
                mutable.append(workExperience(item, key: key))
                if key != .workingHistory && value.last?.id != item.id {
                    mutable.append(spacer2)

                }
            }
            mutable.append(spacer)
        }
        mutable.removeAttribute(.underlineStyle, range: .init(location: 0, length: mutable.length))
        return mutable
    }
    
    private func title(_ text:String) -> NSAttributedString {
        let attachemnt = NSMutableAttributedString(attachment: .init(image: .init(resource: .pen).changeSize(newWidth: 20)))
        attachemnt.addAttributes([
            .link: URL(string: "action://\(text.replacingOccurrences(of: " ", with: ""))")!,
        ], range: .init(location: 0, length: attachemnt.length))
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        attachemnt.append(.init(string: "\(text)\n".uppercased(), attributes: [
            .link: URL(string: "action://\(text.replacingOccurrences(of: " ", with: ""))")!,
                .font:(appearence.font[.section] ?? Appearence.FontData.default(.section)).font,
            .foregroundColor:appearence.toColor(.section),
           // .paragraphStyle:paragraphStyle
        ]))
        attachemnt.addAttributes([.paragraphStyle:paragraphStyle], range: .init(location: 0, length: attachemnt.length))
        return attachemnt
    }
    
    private var spacer:NSAttributedString {
//        let spacerAttachment = NSTextAttachment()
//        spacerAttachment.bounds = CGRect(x: 0, y: 0, width: 0, height: appearence.spaceBeforeSection)
//        return NSAttributedString(attachment: spacerAttachment)
        .init(string: "\n", attributes: [
            .font:UIFont.systemFont(ofSize: 5)
        ])
//        .init()
    }
    
    private var separetor:NSAttributedString {
//        let spacerAttachment = NSTextAttachment()
//        spacerAttachment.bounds = CGRect(x: 0, y: 0, width: 0, height: appearence.spaceBeforeText)
//        return NSAttributedString(attachment: spacerAttachment)
//        let view = UIView()
//        view.backgroundColor = appearence.toColor(.separetor)
//        view.frame = .init(origin: .zero, size: .init(width: PDFGeneratorModel.pdfWidth, height: 1))
//        let attachment = NSTextAttachment()
//        attachment.image = view.toImage
//        return .init(attachment: attachment)
        .init()
//        return .init(string: "\n", attributes: [
//            .font:UIFont.systemFont(ofSize: 5),
//        ])
//        .init()
    }
    
    private var spacer2:NSAttributedString {
        return .init(string: "\n", attributes: [
            .font:UIFont.systemFont(ofSize: 5),
        ])
    }
    
    func workExperience(_ item:CVContent.ContentItem, key:CVContent.Key) -> NSAttributedString {
        let mutable:NSMutableAttributedString = .init()
        var companyName = item.title
        if companyName.isEmpty {
            companyName = key.pdfPreviewTitlePlaceholder
        }
        if !companyName.isEmpty  {
//            let attachment = NSTextAttachment(image: .init(resource: .pen).changeSize(newWidth: 20), attributes:[])
            
            let attachemnt = NSMutableAttributedString(attachment: .init(image: .init(resource: .pen).changeSize(newWidth: 20)))
            attachemnt.addAttributes([
                .link: URL(string: "action://\(key.rawValue)\(item.id.uuidString)")!
            ], range: .init(location: 0, length: attachemnt.length))
//                    return .init(attachment: attachment)
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            let isCVTitle = key.rawValue.lowercased().contains("title")
            let keyType: ContentType = isCVTitle ? (key == .jobTitle ? .cvTitle : .smallDescription) : .title
            let font = (appearence.font[keyType] ?? Appearence.FontData.default(keyType)).font
            let title:NSAttributedString = .init(string: companyName + (key.pdfTextInline ? " " : "    "), attributes: [
                .foregroundColor:appearence.toColor(keyType),
                .font:font,
//                .link: URL(string: "action://\(key.rawValue)\(item.id.uuidString)")!,
                .paragraphStyle: isCVTitle ? paragraphStyle : NSMutableParagraphStyle(),

            ])

            if !exportPDFPressed {
                mutable.append(attachemnt)
                
                mutable.append(.init(string: "  "))
            }
            mutable.append(title)
            if !exportPDFPressed {
                mutable.addAttributes([.paragraphStyle:isCVTitle ? paragraphStyle : NSMutableParagraphStyle()], range: .init(location: 0, length: mutable.length))
            }
        }
        
        if let date = item.from, key.needDates {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .right
let font = (appearence.font[.smallDescription] ?? Appearence.FontData.default(.smallDescription)).font
            //paragraphSpacingBefore = -12
            let date:NSAttributedString = .init(string: "\(item.from?.formatted(date: .complete, time: .standard) ?? "") ", attributes: [
                .font:font,
                .foregroundColor:appearence.toColor(.smallDescription),
                .paragraphStyle:paragraphStyle,
            ])
            mutable.append(date)
            mutable.append(.init(string: "\n"))
        }
        if !item.titleDesctiption.isEmpty {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .left
//            paragraphStyle.paragraphSpacingBefore = -11
          //  paragraphStyle.paragraphSpacing = 100
            let font = (appearence.font[.smallDescription] ?? Appearence.FontData.default(.smallDescription)).font
            print(font, " rtegrfwdes ")
            let description:NSAttributedString = .init(string: item.titleDesctiption, attributes: [
                .foregroundColor:appearence.toColor(.smallDescription),
                .paragraphStyle: key == .workingHistory ? paragraphStyle : NSMutableParagraphStyle(),
                .font:font,

            ])
            mutable.append(description)
            mutable.append(.init(string: "\n"))
        }
        if !item.text.isEmpty {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .left
//            paragraphStyle.paragraphSpacingBefore = -11
            let font = (appearence.font[.text] ?? Appearence.FontData.default(.text)).font
            print(font, " rgterfsdx ")
            mutable.append(.init(string: item.text + "\n", attributes: [
                .paragraphStyle: key == .workingHistory ? paragraphStyle : NSMutableParagraphStyle(),
                .foregroundColor: appearence.toColor(.text),
                .font:font,
            ]))
            
            let bolds = item.boldTexts.components(separatedBy: ", ")
            bolds.forEach { string in
                if let range = mutable.string.range(of: string) {
                    mutable.addAttributes([
                        .font:UIFont.systemFont(ofSize: font.pointSize, weight: .bold)
                    ], range: .init(range, in: mutable.string))

                }
            }
            
        }
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
    
    var editingboldTexts:String {
        get {
            editingValue?.boldTexts ?? ""
        }
        set {
            editingValue?.boldTexts = newValue
        }
    }
    
    var editingDateFrom:Date {
        get {
            editingValue?.from ?? .init()
        }
        set {
            editingValue?.from = newValue
        }
    }
    
    var editingDateTo:Date {
        get {
            editingValue?.to ?? .init()
        }
        set {
            editingValue?.to = newValue
        }
    }
    
    var selectingFontSize:CGFloat {
        get {
            appearence.font[fontSelectingFor ?? .background]?.size ?? Appearence.FontData.default(fontSelectingFor ?? .background).size
        }
        set {
            var font = appearence.font[fontSelectingFor ?? .background] ?? Appearence.FontData.default(fontSelectingFor ?? .background)
            font.size = newValue
            appearence.font.updateValue(font, forKey: fontSelectingFor!)
        }
    }
    
    var selectingFontWeight:UIFont.Weight {
        get {
            appearence.font[fontSelectingFor ?? .background]?.fontWeight ?? Appearence.FontData.default(fontSelectingFor ?? .background).fontWeight
        }
        set {
            var font = appearence.font[fontSelectingFor ?? .background] ?? Appearence.FontData.default(fontSelectingFor ?? .background)
            font.fontWeight = newValue
            appearence.font.updateValue(font, forKey: fontSelectingFor!)
        }
    }
}
