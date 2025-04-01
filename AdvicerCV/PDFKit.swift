//
//  PDFKit.swift
//  AdvicerCV
//
//  Created by Mykhailo Dovhyi on 08.03.2025.
//

import PDFKit

#warning("refactoring: move to model")
extension String {
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
    static func extractTextAfterTitle(from pdfURL: URL, title: String) -> String? {
        print(pdfURL.absoluteString, " erfwedawsa")
        if pdfURL.startAccessingSecurityScopedResource() {
            defer { pdfURL.stopAccessingSecurityScopedResource() }
#warning("from data indeed url")
            guard let pdfDocument = PDFDocument(url: pdfURL) else {
                print("Could not load PDF.")
                return nil
            }
            
            for pageIndex in 0..<pdfDocument.pageCount {
                guard let page = pdfDocument.page(at: pageIndex) else { continue }
                
                let pageText = page.string ?? ""
                
                if let titleRange = pageText.range(of: title, options: .caseInsensitive) {
                    let textAfterTitle = String(pageText[titleRange.upperBound...])
                    return textAfterTitle
                }
            }
            
            return nil
        }
        return nil
    }
}

