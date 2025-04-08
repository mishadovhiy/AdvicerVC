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
