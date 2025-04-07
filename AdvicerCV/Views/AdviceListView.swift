//
//  AdviceListView.swift
//  AdvicerCV
//
//  Created by Mykhailo Dovhyi on 01.04.2025.
//

import SwiftUI

struct AdviceListView: View {
    @Binding var selectedDocument:Document?
    @EnvironmentObject var db: AppData
    let regenerateAdvicePressed:()->()
    var body: some View {
        NavigationView {
            VStack {
                LazyVGrid(columns: [.init(), .init()]) {
                    ForEach(db.db.coduments, id:\.url?.absoluteString) { item in
                        VStack {
                            Text(item.url?.lastPathComponent ?? "-")
                            PDFKitView(pdfData: item.data)
                            
                        }
                        .aspectRatio(1, contentMode: .fit)
                        .background(Color.secondary)
                        .cornerRadius(10)
                        .onTapGesture {
                            withAnimation {
                                selectedDocument = item
                            }
                        }
                    }
                }
                Spacer()
                VStack {
                    NavigationLink("", destination: AdviceView(document: $selectedDocument, regeneratePressed: regenerateAdvicePressed), isActive: .init(get: {
                        selectedDocument != nil
                    }, set: { newValue in
                        if !newValue {
                            selectedDocument = nil
                        }
                    }))
                    
                }
                .hidden()
            }
            .background {
                ClearBackgroundView()
            }
            .frame(width: db.deviceSize.width)
            
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .background(ClearBackgroundView())
        
    }
    
}
