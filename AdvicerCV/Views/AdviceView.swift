//
//  AdviceView.swift
//  AdvicerCV
//
//  Created by Mykhailo Dovhyi on 01.04.2025.
//

import SwiftUI

struct AdviceView: View {
    @EnvironmentObject var db: DB
    let document:DataBase.Document?
    
    var body: some View {
        if let document = document?.data {
            PDFKitView(pdfData: document)
        } else {
            Text("error loading document")
        }
    }
}

#Preview {
    AdviceView(document: .init())
}
