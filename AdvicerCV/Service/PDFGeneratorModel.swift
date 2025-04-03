//
//  PDFGeneratorModel.swift
//  AdvicerCV
//
//  Created by Mykhailo Dovhyi on 02.04.2025.
//

import UIKit
import CoreGraphics

struct PDFGeneratorModel {
    func savePDFDataToTempFile(data: Data, fileName: String) -> URL? {
        let tempDirectory = FileManager.default.temporaryDirectory
        let url = tempDirectory.appendingPathComponent(fileName)
        
        do {
            try data.write(to: url)
            return url
        } catch {
            print("Error writing PDF to file: \(error)")
            return nil
        }
    }
    
    func generatePDF(from attributedString: NSAttributedString) -> Data {
        let width = 595
        // Set up page size
        let pageSize = CGSize(width: width, height: 842) // A4 height
        let textInsets = UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40)
        let textWidth = pageSize.width - textInsets.left - textInsets.right
        let textHeight = pageSize.height - textInsets.top - textInsets.bottom
        
        // Create framesetter for Core Text pagination
        let framesetter = CTFramesetterCreateWithAttributedString(attributedString)
        var currentRange = CFRange(location: 0, length: 0)
        
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(origin: .zero, size: pageSize))
        
        let pdfData = pdfRenderer.pdfData { context in
            while currentRange.location < attributedString.length {
                context.beginPage()
                
                let currentContext = context.cgContext
                currentContext.translateBy(x: 0, y: pageSize.height)
                currentContext.scaleBy(x: 1.0, y: -1.0)
                
                let frameRect = CGRect(
                    x: textInsets.left,
                    y: textInsets.bottom,
                    width: textWidth,
                    height: textHeight
                )
                
                let path = CGMutablePath()
                path.addRect(frameRect)
                
                // Create a frame for this page
                let frame = CTFramesetterCreateFrame(
                    framesetter,
                    currentRange,
                    path,
                    nil
                )
                
                CTFrameDraw(frame, currentContext)
                
                // Update the range for the next page
                let visibleRange = CTFrameGetVisibleStringRange(frame)
                currentRange = CFRange(
                    location: currentRange.location + visibleRange.length,
                    length: 0
                )
            }
        }
        
        return pdfData
    }
}
