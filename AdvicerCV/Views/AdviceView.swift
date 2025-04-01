//
//  AdviceView.swift
//  AdvicerCV
//
//  Created by Mykhailo Dovhyi on 01.04.2025.
//

import SwiftUI

struct AdviceView: View {
    @EnvironmentObject var db: AppData
    @Binding var document:Document?
    let regeneratePressed:()->()
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing:0) {
                PDFKitView(pdfData: document?.data)
                    .frame(width: db.deviceSize.width - (db.deviceSize.width / 10))
                ScrollView(.vertical, content: {
                    rightControlView
                        .frame(width: db.deviceSize.width - (db.deviceSize.width / 10), height: db.deviceSize.height)
                })
                
            }
        }
        .background(.red)
        .transition(.asymmetric(insertion: .scale, removal: .scale))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.orange)
    }
    
    var rightControlView: some View {
        VStack {
            Text("your skills")
            Text(document?.response?.value(for: .skillsGrade) ?? "")
            Color(.blue)
        }
    }
}
