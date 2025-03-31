import Foundation

struct AdviceSection: Codable, Identifiable {
    let id: UUID
    let title: String
    let items: [String]
    
    init(id: UUID = UUID(), title: String, items: [String]) {
        self.id = id
        self.title = title
        self.items = items
    }
}

// Mock data for preview and testing
extension AdviceSection {
    static let mockSections = [
        AdviceSection(title: "Skills", items: [
            "Include both technical and soft skills",
            "Use bullet points for better readability",
            "Prioritize skills relevant to the job"
        ]),
        AdviceSection(title: "Experience", items: [
            "Use action verbs to describe achievements",
            "Quantify results where possible",
            "Keep descriptions concise and impactful"
        ]),
        AdviceSection(title: "Education", items: [
            "List most recent education first",
            "Include relevant coursework",
            "Mention academic achievements"
        ])
    ]
} 