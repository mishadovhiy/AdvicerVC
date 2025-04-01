//
//  HomeView.swift
//  AdvicerCV
//
//  Created by Mykhailo Dovhyi on 01.04.2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject var db:AppData = .init()
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        GeometryReader(content: { proxy in
            VStack {
                tabBarButtons
                HStack(spacing:0) {
                    contenView
                }
            }
            .onChange(of: proxy.size) { newValue in
                db.deviceSize = newValue
            }
            .onAppear {
                db.deviceSize = proxy.size
            }
        })
        .environmentObject(db)
        .sheet(isPresented: $viewModel.isDocumentSelecting) {
            DocumentPicker(onDocumentPicked: {
                viewModel.processDocument($0, db: &db.db)
            })
        }
    }
    
    var contenView: some View {
        ForEach(HomeViewModel.PresentingTab.allCases, id:\.rawValue) { tab in
            switch tab {
            case .home:homeView
                    .frame(maxWidth: viewModel.selectedTab == .home ? .infinity : 0)
                    .animation(.bouncy, value: viewModel.selectedTab)
                    .clipped()
            case .advices:
                AdviceListView(selectedDocument: $viewModel.selectedDocument)
                    .frame(maxWidth: viewModel.selectedTab == .advices ? .infinity : 0)
                    .animation(.bouncy, value: viewModel.selectedTab)
                    .clipped()
            case .settings:
                Text("Settings")
                    .frame(maxWidth: viewModel.selectedTab == .settings ? .infinity : 0)
                    .animation(.bouncy, value: viewModel.selectedTab)
                    .clipped()
            }
        }

    }
    
    var homeView: some View {
        VStack {
            Spacer()
            uploadButton
            Spacer()
        }
    }
    
    var uploadButton: some View {
        Button(action: {
            viewModel.isDocumentSelecting = true
        }) {
            HStack {
                Image(systemName: "arrow.up.doc")
                Text("Upload CV")
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }
    
    var tabBarButtons: some View {
        HStack {
            Text("\(db.db.coduments.count)")
            ForEach(HomeViewModel.PresentingTab.allCases, id:\.rawValue) { tab in
                Button(tab.title) {
                    withAnimation {
                        viewModel.selectedTab = tab
                    }
                }
            }
        }
    }
}


#Preview {
    HomeView()
} 
