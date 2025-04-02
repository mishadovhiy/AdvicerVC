//
//  Document.swift
//  AdvicerCV
//
//  Created by Mykhailo Dovhyi on 01.04.2025.
//

import Foundation

struct Document: Codable {
    //pdfDocumentData
    var data:Data?
    var url:URL?
    var request:PromtOpenAI? = nil
    var response:AdviceResponse? = nil
    
    var responseHistory:[AdviceResponse] = []
}

extension [Document] {
    mutating func update(_ newValue:Document) {
        var newValue = newValue
        var found = false
        for i in 0..<self.count {
            if !found && self[i].url?.absoluteString == newValue.url?.absoluteString {
                found = true
                newValue.responseHistory = self[i].responseHistory
                newValue.responseHistory.append(self[i].response ?? .init(data: [:]))
                self[i] = newValue
                return
            }
        }
        if !found {
            self.append(newValue)
        }
    }
}

