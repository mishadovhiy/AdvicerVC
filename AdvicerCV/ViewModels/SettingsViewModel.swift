//
//  SettingsViewModel.swift
//  AdvicerCV
//
//  Created by Mykhailo Dovhyi on 23.04.2025.
//

import Foundation
import UIKit

struct SettingsViewModel {
    var navigationPresenting:NavigationPresenting = .init()
    var supportRequest:NetworkRequest.SupportRequest = .init()
    var supportRequestCompleted:MessageContent?
    var isNavigationPushed:Bool {
        let dict = navigationPresenting.dictionary as? [String:Bool]
        return dict?.values.contains(true) ?? false
    }
    
    func sendSupportRequest(completion:@escaping(_ ok:Bool)->()) {
        NetworkModel().support(supportRequest) { response in
            completion(response?.success ?? false)
        }
    }
    
    
    func unparcePrivacyPolicy(_ response:String) -> String {
                        """
        <!DOCTYPE html>
        <html lang="en">
        <head>
        </head>
        <style>
        html, body{background: #3A3A3A;}
        h2{ font-size: 18px; color: white; }h1{font-size: 32px; color: white;}
        p{font-size: 12px; color: white;}
        </style>
        <body>
        """ + (response.extractSubstring(key: "!--Privacy--", key2: "!--/Privacy--") ?? "") + """
            </body>
            </html>
            """
    }
    
    var privacyPolicyContent:String = ""
    func fetchPrivacyPolicy(completion:@escaping(_ html:String)->()) {
        DispatchQueue(label: "api", qos: .userInitiated).async {
            NetworkModel().fetchHTM(.init(url: Keys.privacyPolicy.rawValue)) { response in
                print(response.response, " gtefrwdsaz ")
                completion(unparcePrivacyPolicy(response.response))
            }
        }
    }
    
    
    
    func openWebsitePressed() {
        if let url = URL(string: Keys.websiteURL.rawValue) {
            UIApplication.shared.open(url)
        }
    }
    
    let aboutData:[AboutView.ContentItem] = [
        .init(title: "How It Works:", description: "CV Master is your go-to app for improving and creating professional CVs with the help of AI. The app provides two key features:"),
        .init(title: "1. CV Improvement Suggestions:"),
        .init(title: "", description: "Upload your CV, and the app will automatically extract all sections, including \(NetworkRequest.Advice.RetriveTitles.allCases.filter({$0.openAIUsed}).compactMap({$0.titles.first}).joined(separator: ", ")).", hasBullets: true),
        .init(title: "", description: "The AI will analyze each section and provide grades and suggestions on how to improve your CV for maximum impact.", hasBullets: true),
        .init(title: "", description: "ll requests and analyses are stored in the app's local database, and you have full control over your data – delete anything you no longer need.", hasBullets: true),
        .init(title: "2. CV Template Generator:"),
        .init(title: "", description: "Choose from a variety of professional templates. Fill in the necessary sections such as \(NetworkRequest.Advice.RetriveTitles.allCases.compactMap({$0.titles.first}).joined(separator: ", ")).", hasBullets: true),
        .init(title: "", description: "Once completed, export your customized CV as a PDF and share it with potential employers or save it for future use.", hasBullets: true),
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
