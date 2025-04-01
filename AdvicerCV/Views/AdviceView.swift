//
//  AdviceView.swift
//  AdvicerCV
//
//  Created by Mykhailo Dovhyi on 01.04.2025.
//

import SwiftUI

struct AdviceView: View {
    @EnvironmentObject var db: AppData
    @Binding var document:DataBase.Document?

    var body: some View {
        VStack {
//


            
            
                
            
        }


        ScrollView(.horizontal, content: {
            VStack(content:  {
                if let document = document?.data, !document.isEmpty {
                    PDFKitView(pdfData: document)
                }
            })
            .frame(maxWidth: db.deviceSize.width)
            .background(.blue)
            ScrollView(.vertical, content: {
                VStack {
                    
                }
            })
            .frame(width: db.deviceSize.width)
        })
        .background(.red)
        .transition(.asymmetric(insertion: .scale, removal: .scale))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.orange)
    }
}


