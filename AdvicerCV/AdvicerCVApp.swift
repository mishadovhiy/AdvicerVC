//
//  AdvicerCVApp.swift
//  AdvicerCV
//
//  Created by Mykhailo Dovhyi on 08.03.2025.
//

import SwiftUI

@main
struct AdvicerCVApp: App {
    @State var appLoaded:Bool = false
    var body: some Scene {
        WindowGroup {
            VStack(content: {
                if appLoaded {
                    HomeView()
                } else {
                    ProgressView()
                        .progressViewStyle(.circular)
                }
            })
            .background(content: {
                Color(.darkBlue)
                    .ignoresSafeArea(.all)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            })
                .onAppear {
                    DispatchQueue.init(label: "db", qos: .userInitiated).async {
                        NetworkModel().loadAppSettings {
                            DispatchQueue.main.async {
                                appLoaded = true
                            }
                        }
                    }
                    UITextView.appearance().backgroundColor = .clear
                    let appearance = UINavigationBarAppearance()
                     appearance.configureWithOpaqueBackground()
                     
//                     appearance.backgroundColor = .blue
                     appearance.titleTextAttributes = [.foregroundColor: UIColor.white,
                                                       .strokeColor:UIColor.white

                     ]
                    appearance.backButtonAppearance.normal.backgroundImage = nil
                     appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white,
                                                            .strokeColor:UIColor.white

                     ]
                     appearance.backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white,
                                                                                   .strokeColor:UIColor.white
                     ]
                    appearance.backgroundColor = .clear
                
                     UINavigationBar.appearance().standardAppearance = appearance
                     UINavigationBar.appearance().scrollEdgeAppearance = appearance
                }
//            GeneratorPDFView()
        }
    }
}
