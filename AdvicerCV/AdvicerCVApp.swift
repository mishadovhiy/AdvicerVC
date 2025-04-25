//
//  AdvicerCVApp.swift
//  AdvicerCV
//
//  Created by Mykhailo Dovhyi on 08.03.2025.
//

import SwiftUI

@main
struct AdvicerCVApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .onAppear {
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
