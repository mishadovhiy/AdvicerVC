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
            VStack(spacing:-10) {
                tabBarButtons
                HStack(spacing:0) {
                    contenView
                }
                .padding(.bottom, 5)
                .background(viewModel.selectedTab.color)
                .cornerRadius(20)
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
                self.loadDocument($0)
            })
        }
    }
    
    func loadDocument(_ url:URL) {
        viewModel.processDocument(url) {
            self.db.db.coduments.update(self.viewModel.selectedDocument!)
        }
    }
    
    var contenView: some View {
        ForEach(HomeViewModel.PresentingTab.allCases, id:\.rawValue) { tab in
            switch tab {
            case .generator:
                GeneratorPDFView()
                    .frame(maxWidth: viewModel.selectedTab == .generator ? .infinity : 0)
                    .animation(.bouncy, value: viewModel.selectedTab)
                    .clipped()
            case .home:homeView
                    .frame(maxWidth: viewModel.selectedTab == .home ? .infinity : 0)
                    .animation(.bouncy, value: viewModel.selectedTab)
                    .clipped()
            case .advices:
                AdviceListView(selectedDocument: $viewModel.selectedDocument, regenerateAdvicePressed: {
                    if let url = viewModel.selectedDocument?.url {
                        viewModel.selectedTab = .home
                        viewModel.selectedDocument = nil
                        self.loadDocument(url)

                    }
                })
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
            .frame(maxHeight: 50)
        }
    }
    
    var tabBarButtons: some View {
        HStack(spacing:-10) {
            ForEach(HomeViewModel.PresentingTab.allCases, id:\.rawValue) { tab in
                Button(tab.title + (tab == .advices ? " (\(db.db.coduments.count))" : "")) {
                    withAnimation {
                        viewModel.selectedTab = tab
                    }
                }
                .zIndex(viewModel.selectedTab == tab ? 10 : 1)
                .padding(.top, 7)
                .padding(.bottom, 12)
                .padding(.horizontal, 20)
                .background(tab.color)
                .cornerRadius(10)
                .animation(.easeInOut, value: viewModel.selectedTab)
            }
            Spacer()
        }
        .padding(.leading, 25)
    }
}


#Preview {
    HomeView()
} 
