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
            HStack() {
                Spacer().frame(width:25)
                VStack(spacing:0) {
                    contenView
                }
                .frame(maxHeight: .infinity)
                .padding(.bottom, 5)
                .background(viewModel.selectedTab.color)
                .cornerRadius(20)
            }
            .background(content: {
                HStack(content:  {
                    tabBarButtons
                    Spacer()
                })
            })
            .onChange(of: proxy.size) { newValue in
                db.deviceSize = newValue
            }
            .onAppear {
                db.deviceSize = proxy.size
            }
        })
        .environmentObject(db)
        .background(.black)
        .sheet(isPresented: $viewModel.isDocumentSelecting) {
            DocumentPicker(onDocumentPicked: {
                self.loadDocument($0)
            })
        }
    }
    
    func loadDocument(_ url:URL) {
        viewModel.processDocument(url) {
            self.db.db.documents.update(self.viewModel.selectedDocument!)
        }
    }
    
    var contenView: some View {
        ForEach(HomeViewModel.PresentingTab.allCases, id:\.rawValue) { tab in
            switch tab {
            case .generator:
                GeneratorPDFView()
                    .frame(maxHeight: viewModel.selectedTab == .generator ? .infinity : 0)
                    .animation(.smooth, value: viewModel.selectedTab)
                    .clipped()
            case .home:homeView
                    .frame(maxHeight: viewModel.selectedTab == .home ? .infinity : 0)
                    .animation(.smooth, value: viewModel.selectedTab)
                    .clipped()
            case .advices:
                AdviceListView(selectedDocument: $viewModel.selectedDocument, regenerateAdvicePressed: {
                    if let url = viewModel.selectedDocument?.url {
                        viewModel.selectedTab = .home
                        viewModel.selectedDocument = nil
                        self.loadDocument(url)

                    }
                })
                    .frame(maxHeight: viewModel.selectedTab == .advices ? .infinity : 0)
                    .animation(.smooth, value: viewModel.selectedTab)
                    .clipped()
//            case .settings:
//                Text("Settings")
//                    .frame(maxHeight: viewModel.selectedTab == .settings ? .infinity : 0)
//                    .animation(.smooth, value: viewModel.selectedTab)
//                    .clipped()
            }
        }

    }
    
    var homeView: some View {
        VStack {
            Spacer()
            uploadButton
            Spacer()
        }
        .frame(maxHeight: .infinity)
    }
    
    var uploadButton: some View {
        VStack(content: {
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
            Text(AppData.adviceLimit <= db.db.documents.count ? "Limit reached" : "")
                
        })
        .disabled(AppData.adviceLimit <= db.db.documents.count)
    }
    
    var tabBarButtons: some View {
        HStack {
            HStack(spacing:-15) {
                ForEach(HomeViewModel.PresentingTab.allCases, id:\.rawValue) { tab in
                    Button(action: {
                        withAnimation {
                            viewModel.selectedTab = tab
                        }
                    }, label: {
                        Text(tab.title)
                            .lineLimit(1)
                    })


    //                .zIndex(viewModel.selectedTab == tab ? 10 : 1)
    //                    .padding(.top, 0)
    //                    .padding(.bottom, 0)
    //                .padding(.horizontal, 20)
                    .padding(.horizontal, 20)
                    .padding(.top, 15)
                    .padding(.bottom, 5)
                    .background(tab.color)
                    .cornerRadius(10)
                    .animation(.easeInOut, value: viewModel.selectedTab)
                    .disabled(!((tab != .advices) || (tab == .advices && !db.db.documents.isEmpty)))
                }
            }
            .frame(height:150)
            .rotationEffect(.degrees(90))

            .offset(x:-130, y:db.deviceSize.height / -4)
            Spacer()
        }
        .frame(alignment:.leading)
    }
}


#Preview {
    HomeView()
} 
