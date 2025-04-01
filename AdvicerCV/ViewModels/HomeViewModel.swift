//
//  HomeViewModel.swift
//  AdvicerCV
//
//  Created by Mykhailo Dovhyi on 01.04.2025.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

class HomeViewModel: ObservableObject {
    @Published var adviceSections: [AdviceSection] = []
    @Published var selectedTab: PresentingTab = .home
    @Published var selectedDocument:Document? {
        willSet {
            if selectedTab != .advices {
                withAnimation {
                    selectedTab = .advices
                }
            }
        }
        didSet {
            if loading == .document {
                loading = nil
            }
        }
    }
    @Published var loading:Loading? = nil
    @Published var isDocumentSelecting = false

    init() {
        adviceSections = AdviceSection.mockSections
    }

    
    // MARK: - Document Processing
    func processDocument(_ url: URL, completion:@escaping()->()) {
        self.loading = .document
        let data = String.pdfToData(from: url)!
        let test = String.extractTextAfterTitle(from: url, title: "Skills")
        let advice = PromtOpenAI.Advice.init(skills: test)
        var newDocument:Document = .init(data: data, url: url, request: .advice(advice))
        DispatchQueue(label: "api", qos: .userInitiated).async {
            NetworkModel().advice(advice) { response in
                newDocument.response = response
                print(response, " gterfwedasx ")
                DispatchQueue.main.async {
                    self.selectedDocument = newDocument
                    completion()
                }
            }
        }
    }
}

extension HomeViewModel {
    enum Loading:String {
        case document
    }
    enum PresentingTab:String, CaseIterable {
        case home
        case advices
        case settings
        var title:String {
            rawValue.addSpaceBeforeCapitalizedLetters.uppercased()}
    }
}
