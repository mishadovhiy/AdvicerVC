//
//  AdviceViewModel.swift
//  AdvicerCV
//
//  Created by Mykhailo Dovhyi on 01.04.2025.
//

import Foundation

class AdviceViewModel: ObservableObject {
    @Published var document:Document?
    @Published var isLoading:Bool = false
    func doneEditingJobTitle(_ db:inout DataBase, newValue:String) {
        var advice = document?.request?.advice ?? .init([:])
        advice.dict.updateValue(newValue, forKey: NetworkRequest.Advice.RetriveTitles.jobTitle.rawValue)
        document?.request = .advice(advice)
        print(document?.request?.advice?.text(for: .jobTitle), " tregfrdw ")
        updateDB(&db)
    }
    
    func updateDB(_ db:inout DataBase) {
        if let id = document?.id,
           let index = db.documents.firstIndex(where: { indexDoc in
               indexDoc.id == id
           }) {
            db.documents[index] = document ?? .init()
            print(db.documents[index].request?.advice?.text(for: .jobTitle), " gtefrdesas ")

        }
    }
    
    
    func generatePressed(completion:@escaping()->()) {
        if let advice = document?.request?.advice {
            isLoading = true
            DispatchQueue(label: "api", qos: .userInitiated).async {
                NetworkModel().advice(advice) { response in
                    print(response, " gterfwedasx ")
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.document?.response = response
                        completion()
                    }
                }
            }
        }
        
    }
}
