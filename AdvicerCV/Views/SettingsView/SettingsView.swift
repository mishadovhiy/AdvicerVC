//
//  SettingsView.swift
//  AdvicerCV
//
//  Created by Mykhailo Dovhyi on 22.04.2025.
//

import SwiftUI

struct SettingsViewModel {
    var navigationPresenting:NavigationPresenting = .init()
    var isNavigationPushed:Bool {
        let dict = navigationPresenting.dictionary as? [String:Bool]
        return dict?.values.contains(true) ?? false
    }
    
    let aboutData:[AboutView.ContentItem] = [
        .init(title: "How It Works:", description: "CV Master is your go-to app for improving and creating professional CVs with the help of AI. The app provides two key features:"),
        .init(title: "1. CV Improvement Suggestions:"),
        .init(title: "", description: "Upload your CV, and the app will automatically extract all sections, including \(NetworkRequest.Advice.RetriveTitles.allCases.filter({$0.openAIUsed}).compactMap({$0.titles.first}).joined(separator: ", "))."),
        .init(title: "", description: "The AI will analyze each section and provide grades and suggestions on how to improve your CV for maximum impact."),
        .init(title: "", description: "ll requests and analyses are stored in the app's local database, and you have full control over your data – delete anything you no longer need."),
        .init(title: "2. CV Template Generator:"),
        .init(title: "", description: "Choose from a variety of professional templates. Fill in the necessary sections such as \(NetworkRequest.Advice.RetriveTitles.allCases.compactMap({$0.titles.first}).joined(separator: ", "))."),
        .init(title: "", description: "Once completed, export your customized CV as a PDF and share it with potential employers or save it for future use."),
        .init(title: "Key Features:"),
        .init(title: "", description: "AI-Driven Advice: Get detailed feedback on your CV’s effectiveness and suggestions for improvement."),
        .init(title: "", description: "Local Data Storage: Your CVs and request data are stored securely in the local database, giving you full privacy control."),
        .init(title: "", description: "Template-Based CV Generation: Easily create a polished, professional CV from templates."),
        .init(title: "", description: "PDF Export: Once you’ve completed your CV, export it as a professional PDF ready for submission.")
    ]
    
    struct NavigationPresenting:Codable {
        var support = false
        var share = false
        var rate = false
        var about = false
        var clearData = false
    }
    
    
}

struct SettingsView: View {
    @State var viewModel:SettingsViewModel = .init()
    @EnvironmentObject var db:AppData
    var body: some View {
        NavigationView {
            VStack(alignment:.leading, spacing: 20) {
                NavigationLink("About", destination: AboutView(viewModel: $viewModel))
                Button("Rate") {
                    StorekitModel().requestReview()
                }
                Button("Share") {
                    viewModel.navigationPresenting.share = true
                }
                NavigationLink("Support", destination: SupportView())
                Button("clear data") {
                    viewModel.navigationPresenting.clearData = true
                }
                .tint(.red)

                Spacer()
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 5)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .sheet(isPresented: $viewModel.navigationPresenting.share) {
            ShareSheet(items: [Keys.shareAppURL])
        }
        .confirmationDialog("Are you sure you want to delete all your data?", isPresented: $viewModel.navigationPresenting.clearData) {
            Button("Yes") {
                viewModel.navigationPresenting.clearData = false
                db.db = .init()
            }
            Button("Cancel") {
                viewModel.navigationPresenting.clearData = false
            }
        }
    }
}

#Preview {
    SettingsView()
}
