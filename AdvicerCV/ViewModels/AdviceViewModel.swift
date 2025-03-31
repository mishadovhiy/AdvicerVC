import Foundation
import SwiftUI
import UniformTypeIdentifiers

class AdviceViewModel: ObservableObject {
    @Published var adviceSections: [AdviceSection] = []
    
    init() {
        // Load mock data initially
        adviceSections = AdviceSection.mockSections
    }
    
    // MARK: - Document Picker Configuration
    var documentTypes: [UTType] {
        [.pdf]
    }
    
    // MARK: - Document Processing
    func processDocument(_ url: URL) {
        // Here you would implement the actual document processing logic
        // For now, we'll just use the mock data
        let test = String.extractTextAfterTitle(from: url, title: "Skills")
        print(test, " ytgerfedsa ")
        DispatchQueue.init(label: "db", qos: .userInitiated).async {
            NetworkModel().advice(.init(skills: test)) { response in
                print(response, " tgerfwed")
            }
        }
        adviceSections = AdviceSection.mockSections
    }
} 
