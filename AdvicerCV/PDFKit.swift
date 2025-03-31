//
//  PDFKit.swift
//  AdvicerCV
//
//  Created by Mykhailo Dovhyi on 08.03.2025.
//

import PDFKit

extension String {
    static func extractTextAfterTitle(from pdfURL: URL, title: String) -> String? {
        print(pdfURL.absoluteString, " erfwedawsa")
        if pdfURL.startAccessingSecurityScopedResource() {
            defer { pdfURL.stopAccessingSecurityScopedResource() }
            
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

