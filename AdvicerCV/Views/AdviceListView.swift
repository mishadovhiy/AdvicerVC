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
            ScrollView(.vertical, content: {
                VStack {
                    Text("Advice List")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 30)
                        .padding(.bottom, -20)
                        .padding(.leading, 25)
                    if db.db.documents.isEmpty {
                        Spacer().frame(height: 80)
                        noDataView
                    }
                    adviceList
                        .padding(20)
                    Spacer()
                    navigationLinks
                }
                .background {
                    ClearBackgroundView()
                }
                .frame(width: db.deviceSize.width)
            })
            .background(ClearBackgroundView())
        }

        .navigationViewStyle(StackNavigationViewStyle())
        .background(ClearBackgroundView())
        .background(HomeViewModel.PresentingTab.advices.color)
        .frame(maxHeight: .infinity)

    }
    
    
    var noDataView: some View {
        VStack {
            Text("CV advice list is empty")
            Text("Upload your first document")
        }
    }
    
    var navigationLinks: some View {
        VStack {
            NavigationLink("", destination: AdviceView(document: $selectedDocument), isActive: .init(get: {
                selectedDocument != nil
            }, set: { newValue in
                if !newValue {
                    selectedDocument = nil
                }
            }))
            
        }
        .hidden()
    }
    
    var adviceList: some View {
        ForEach(db.db.documents, id:\.url?.absoluteString) { item in
            VStack {
                Text(item.url?.lastPathComponent ?? "-")
                    .foregroundColor(.lightBlue)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 10)
                    .padding(.horizontal, 10)
                PDFKitView(pdfData: item.data)
                    .disabled(true)
                    .cornerRadius(10)

            }
            .frame(maxWidth:.infinity)
            .frame(height:120)
//                    .aspectRatio(1, contentMode: .fit)
            .background(.darkText)
            .cornerRadius(10)
            .clipped()
            .onTapGesture {
                withAnimation {
                    selectedDocument = item
                }
            }
        }
    }
}
