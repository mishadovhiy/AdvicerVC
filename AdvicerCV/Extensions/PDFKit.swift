//
//  PDFKit.swift
//  AdvicerCV
//
//  Created by Mykhailo Dovhyi on 08.03.2025.
//

import PDFKit

extension PDFDocument {
    static func pdfToData(from pdfURL: URL) -> Data? {
        if pdfURL.startAccessingSecurityScopedResource() {
            defer { pdfURL.stopAccessingSecurityScopedResource() }
            
            guard let pdfDocument = PDFDocument(url: pdfURL) else {
                print("Could not load PDF.")
                return nil
            }
            return pdfDocument.dataRepresentation()
        }
        return nil
    }
    
    static func extractTextAfterTitle(from data: Data, titles: [String]) -> [String:String] {
        var result:[String:String] = [:]
        guard let pdfDocument = PDFDocument(data: data) else {
            print("errorcreatingpdf")
            return [:]
        }
            
            for pageIndex in 0..<pdfDocument.pageCount {
                guard let page = pdfDocument.page(at: pageIndex) else { continue }
                
                let pageText = page.string?.uppercased() ?? ""
                
                titles.forEach { title in
                    if let titleRange = pageText.range(of: title.uppercased(), options: .caseInsensitive) {
                        let textAfterTitle = String(pageText[titleRange.upperBound...])
                        result.updateValue(textAfterTitle, forKey: title)
                    }
                }
                
            }
            
            return result
        
//        return []
    }

}
