//
//  HomeViewModel.swift
//  AdvicerCV
//
//  Created by Mykhailo Dovhyi on 01.04.2025.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers
import PDFKit

class HomeViewModel: ObservableObject {
    let tabBarButtonsHeight:CGFloat = 30
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

    
    // MARK: - Document Processing
    func processDocument(_ url: URL, completion:@escaping()->()) {
        self.loading = .document
        let data = PDFDocument.pdfToData(from: url)!
        let test = PDFDocument.extractTextAfterTitle(from: data, titles: NetworkRequest.Advice.RetriveTitles.allCases.compactMap({$0.titles}).flatMap({$0}))
        var adviceResult:[String:String] = [:]
        print("fsda ", test, " rtgerfds")

        NetworkRequest.Advice.RetriveTitles.allCases.forEach { key in
            key.titles.forEach { title in
                if let value = test[title], !value.isEmpty {
                    adviceResult.updateValue(test[title] ?? "", forKey: key.rawValue)

                }
            }
        }
        print(adviceResult, " rtgdfsda ")
        let advice = NetworkRequest.Advice.init(adviceResult)
        print(advice.allValues, " rgtefrds")
        var newDocument:Document = .init(data: data, url: url, request: .advice(advice))
        print("promtsfd ", newDocument.request?.promt, " efrweda ")
                            self.selectedDocument = newDocument
        completion()

//        DispatchQueue(label: "api", qos: .userInitiated).async {
//            NetworkModel().advice(advice) { response in
//                newDocument.response = response
//                print(response, " gterfwedasx ")
//                DispatchQueue.main.async {
//                    self.selectedDocument = newDocument
//                    completion()
//                }
//            }
//        }
    }
}

extension HomeViewModel {
    enum Loading:String {
        case document
    }
    enum PresentingTab:String, CaseIterable {
        case home
        case advices
        case generator
        case settings
//        case settings
        var title:String {
            rawValue.addSpaceBeforeCapitalizedLetters.uppercased()}
        
        var isLeading:Bool {
            switch self {
            case .settings:false
            default:true
            }
        }
        
        var color:Color {
            switch self {
            case .home:
                    .orange
            case .advices:
                    .brown
//            case .settings:
//                    .green
            case .generator:.white
            case .settings:.white
            }
        }
    }
}
