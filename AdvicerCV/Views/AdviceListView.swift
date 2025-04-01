//
//  AdviceListView.swift
//  AdvicerCV
//
//  Created by Mykhailo Dovhyi on 01.04.2025.
//

import SwiftUI

struct AdviceListView: View {
    @Binding var selectedDocument:DataBase.Document?
    @EnvironmentObject var db: DB

    var body: some View {
        NavigationView {
            List(db.db.coduments, id:\.url?.absoluteString) { item in
                Text(item.url?.absoluteString ?? "9")
                    .onTapGesture {
                        withAnimation {
                            selectedDocument = item
                        }
                    }
            }
            .background {
                navigationLinks
            }
        }
    }
    
    var navigationLinks: some View {
        VStack {
            NavigationLink("", destination: AdviceView(document: selectedDocument), isActive: .init(get: {
                selectedDocument != nil
            }, set: { newValue in
                if !newValue {
                    withAnimation {
                        selectedDocument = nil
                    }
                }
            }))
        }
        .hidden()
    }
}

#Preview {
    AdviceListView(selectedDocument: .constant(nil))
}
