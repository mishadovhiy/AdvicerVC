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
                }
//            GeneratorPDFView()
        }
    }
}
