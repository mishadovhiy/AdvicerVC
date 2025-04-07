//
//  PDFView.swift
//  AdvicerCV
//
//  Created by Mykhailo Dovhyi on 01.04.2025.
//

import SwiftUI
import UIKit
import PDFKit

struct PDFKitView: UIViewRepresentable {
    var pdfData: Data?
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.document = PDFDocument(data: pdfData ?? .init())
        pdfView.backgroundColor = .clear
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {
        print(pdfData?.count, "fwedas")
        if pdfData?.isEmpty ?? true {
            print(pdfData?.count, "ETGRFWDA")

            return
        }
        if let pdfData {
            if let document = PDFDocument(data: pdfData) {
                uiView.document = document
            }
        }
        
    }
}
