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
    @Published var selectedDocument:DataBase.Document? {
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
    init() {
        // Load mock data initially
        adviceSections = AdviceSection.mockSections
    }
    
    // MARK: - Document Picker Configuration
    var documentTypes: [UTType] {
        [.pdf]
    }
    
    // MARK: - Document Processing
    func processDocument(_ url: URL, db:inout DataBase) {
        self.loading = .document
        let data = String.pdfToData(from: url)
        let test = String.extractTextAfterTitle(from: url, title: "Skills")
        let newDocument:DataBase.Document = .init(data: data, url: url, request: .advice(.init(skills: test)))
        db.coduments.update(newDocument)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            withAnimation {
                self.selectedDocument = newDocument
            }
        })
    }
} 
