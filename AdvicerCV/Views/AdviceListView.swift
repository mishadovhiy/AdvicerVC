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
            List(db.db.coduments, id:\.url?.absoluteString) { item in
                Text(item.url?.absoluteString ?? "9")
                    .onTapGesture {
                        withAnimation {
                            selectedDocument = item
                        }
                    }
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
            .frame(width: db.deviceSize.width)
        }


    }
    
}
