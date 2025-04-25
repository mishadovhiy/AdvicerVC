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
            HStack(spacing:-10) {
                Spacer().frame(width:viewModel.tabBarButtonsHeight)
                VStack(spacing:viewModel.selectedTab == .home ? -(viewModel.appCornerRadius * 2) : 0) {
                    contenView
                }
                .padding(.trailing, viewModel.selectedTab == .home ? (viewModel.appCornerRadius * -1) : 0)
                .frame(maxHeight: .infinity)
//                .padding(.bottom, 50)
                .background(.black)
                .cornerRadius(viewModel.appCornerRadius)
                .animation(.bouncy, value: viewModel.selectedTab)
            }
            .background(content: {
                HStack(content:  {
                    tabBarButtons(true)
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

            case .advices:
                AdviceListView(selectedDocument: $viewModel.selectedDocument, regenerateAdvicePressed: {
                    if let url = viewModel.selectedDocument?.url {
                        viewModel.selectedTab = .home
                        viewModel.selectedDocument = nil
                        self.loadDocument(url)

                    }
                })
                    .frame(maxHeight: viewModel.selectedTab == .advices || viewModel.selectedTab == .home ? .infinity : 0)
                    .padding(.top, viewModel.selectedTab == .home ? -60 : 0)
                    .padding(.leading, viewModel.selectedTab == .home ? -40 : 0)
                    .animation(.smooth, value: viewModel.selectedTab)
                    .clipped()
                    .disabled(viewModel.selectedTab != .advices)
                    .cornerRadius(viewModel.selectedTab == .home ? viewModel.appCornerRadius : 0)

                    .shadow(radius: viewModel.selectedTab == .home ? 10 : 0)
                    .overlay {
                        RoundedRectangle(cornerRadius: viewModel.appCornerRadius)
                            .fill(HomeViewModel.PresentingTab.advices.color.opacity(viewModel.selectedTab != .advices ? 0.1 : 0))
                            .onTapGesture {
                                if !db.db.documents.isEmpty {
                                    withAnimation {
                                        viewModel.selectedTab = .advices
                                    }
                                }
                                
                            }
                    }
            case .generator:
                GeneratorPDFView(isPresenting: .constant(viewModel.selectedTab == .generator))
                    .frame(maxHeight: viewModel.selectedTab == .generator || viewModel.selectedTab == .home ? .infinity : 0)
                    .clipped()
                    .disabled(viewModel.selectedTab != .generator)
                    .cornerRadius(viewModel.selectedTab == .home ? viewModel.appCornerRadius : 0)
                    .zIndex(viewModel.selectedTab == .generator ? 999 : 0)
                    .animation(.smooth, value: viewModel.selectedTab)


                    .shadow(radius: viewModel.selectedTab == .home ? 10 : 0)
                    .overlay {
                        RoundedRectangle(cornerRadius: viewModel.appCornerRadius)
                            .fill(HomeViewModel.PresentingTab.generator.color.opacity(viewModel.selectedTab != .generator ? 0.1 : 0))
                            .onTapGesture {
                                withAnimation {
                                    viewModel.selectedTab = .generator
                                }
                            }
                    }
            case .home:homeView
                    .frame(maxHeight: viewModel.selectedTab == .home ? .infinity : 0)
                    .animation(.smooth, value: viewModel.selectedTab)
                    .clipped()
                    .disabled(viewModel.selectedTab != .home)
                    .cornerRadius(viewModel.selectedTab == .home ? viewModel.appCornerRadius : 0)
                    .shadow(radius: viewModel.selectedTab == .home ? 10 : 0)

                
            case .settings:SettingsView()
                    .frame(maxHeight: viewModel.selectedTab == .settings ? .infinity : 0)
                    .animation(.smooth, value: viewModel.selectedTab)
                    .clipped()
                    .disabled(viewModel.selectedTab != .settings)
            }
        }

    }
    
    var homeView: some View {
        VStack {
            Spacer()
            uploadButton
            Spacer()
        }
        .padding(.horizontal, 25)
        .background(HomeViewModel.PresentingTab.home.color)
        .frame(maxHeight: .infinity)

    }
    
    var uploadButton: some View {
        VStack(content: {
            VStack() {
                Text("Upload Document")
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .semibold))
                Text("To generate advice with AI")
                    .foregroundColor(.white.opacity(0.4))
                    .font(.system(size: 12, weight: .medium))
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 20)
            Button(action: {
                viewModel.isDocumentSelecting = true
            }) {
                HStack {
                    Image(systemName: "arrow.up.doc")
                    Text("Upload CV")
                        .font(.system(size: 20, weight:.semibold))
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(.Special.red))
                .foregroundColor(.white)
                .cornerRadius(10)
                .frame(maxHeight: 50)
                .shadow(color: .Special.red.opacity(0.3), radius: 7, x:-2, y:-5)
            }
            Text(AppData.adviceLimit <= db.db.documents.count ? "Limit reached" : "")
            
                
        })
        .padding(.top, -100)
        .padding(.trailing, viewModel.selectedTab == .home ? viewModel.appCornerRadius : 0)
        .disabled(AppData.adviceLimit <= db.db.documents.count)
        .animation(.bouncy, value: viewModel.selectedTab)
    }
    
    func tabBarButtons(_ needBackground:Bool) -> some View {
        HStack {
            VStack(spacing:viewModel.selectedTab == .home ? (viewModel.appCornerRadius * -4) : -15) {
                ForEach(HomeViewModel.PresentingTab.allCases.filter({$0.isLeading}), id:\.rawValue) { tab in
                    Button(action: {
                        withAnimation {
                            viewModel.selectedTab = tab
                        }
                    }, label: {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.clear)
                            .overlay {
                                Text(tab.title)
                                    .padding(.top, 10)
                                    .padding(.bottom, 2)
                                    .frame(width:100)
                                    .lineLimit(1)
                                    .rotationEffect(.degrees(90))
                                    .shadow(radius: viewModel.selectedTab == tab ? 4 : 0)
                            }
                        
                    })
                    .tint(Color(uiColor: UIColor(cgColor: tab.color.cgColor ?? UIColor.white.cgColor).isLight ? .black : .white))

    //                .zIndex(viewModel.selectedTab == tab ? 10 : 1)
    //                    .padding(.top, 0)
    //                    .padding(.bottom, 0)
    //                .padding(.horizontal, 20)
//                    .padding(.horizontal, 20)
//                    .padding(.top, 8)
//                    .padding(.bottom, 12)
                    .animation(.easeInOut, value: viewModel.selectedTab)
                    .disabled((tab == .advices && db.db.documents.isEmpty))
                    .frame(maxWidth:.infinity)
                    .frame(height:100)
                    .background(tab.color)
                    .cornerRadius(10)

                    Spacer()
                        .frame(maxHeight:viewModel.selectedTab == .home ? .infinity : 0)
                        .animation(.bouncy, value: viewModel.selectedTab)
                }
                
                Spacer()
                Button("Settings") {
                    viewModel.selectedTab = .settings
                }
                .background(HomeViewModel.PresentingTab.settings.color)
                .cornerRadius(5)
                .padding(.bottom, viewModel.appCornerRadius)
            }
            .animation(.bouncy, value: viewModel.selectedTab)
//            .frame(height:150)
//            .rotationEffect(.degrees(90))

//            .offset(x:-130, y:db.deviceSize.height / -4)
        }
        .frame(alignment:.leading)
        .padding(.top, 25)
        .frame(width:viewModel.tabBarButtonsHeight)
    }
}


#Preview {
    HomeView()
} 
