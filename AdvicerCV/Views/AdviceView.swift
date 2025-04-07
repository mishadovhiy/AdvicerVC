//
//  AdviceView.swift
//  AdvicerCV
//
//  Created by Mykhailo Dovhyi on 01.04.2025.
//

import SwiftUI

struct AdviceView: View {
    @EnvironmentObject var db: AppData
    @Binding var document:Document?
    let regeneratePressed:()->()
    @State var previewPressed:[PromtOpenAI.Advice.RetriveTitles] = []
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing:0) {
                PDFKitView(pdfData: document?.data)
                    .frame(width: db.deviceSize.width - (db.deviceSize.width / 10))
                ScrollView(.vertical, content: {
                    rightControlView
                        .frame(width: db.deviceSize.width - (db.deviceSize.width / 10))
                })
                
            }
        }
        .background(.red)
        .transition(.asymmetric(insertion: .scale, removal: .scale))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.orange)
    }
    
    var rightControlView: some View {
        let cvContent = document?.request?.advice?.allValues ?? [:]
        return VStack {
            Text("Retrived content")
            ForEach(cvContent.keys.sorted(by: {$0.rawValue >= $1.rawValue}).filter({$0.openAIUsed}).compactMap({$0.rawValue}), id:\.self) { item in
                VStack {
                    Button {
                        let key = PromtOpenAI.Advice.RetriveTitles.init(rawValue: item) ?? .contacts
                        if previewPressed.contains(key) {
                            withAnimation {
                                previewPressed.removeAll(where: {
                                    $0.rawValue == key.rawValue
                                })
                            }
                        } else {
                            withAnimation {
                                previewPressed.append(key)
                            }
                        }
                    } label: {
                        HStack {
                            Text((PromtOpenAI.Advice.RetriveTitles.init(rawValue: item) ?? .contacts).rawValue.addSpaceBeforeCapitalizedLetters.capitalized)
                            Spacer()
                            Text((cvContent[.init(rawValue: item) ?? .contacts] ?? "").isEmpty ? "not detected" : "detected")
                        }
                    }

                    Text(cvContent[.init(rawValue: item) ?? .contacts] ?? "")
                        .lineLimit(previewPressed.contains(.init(rawValue: item) ?? .contacts) ? nil : 1)
                }
            }
        }
    }
}
