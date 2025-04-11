//
//  AdviceView.swift
//  AdvicerCV
//
//  Created by Mykhailo Dovhyi on 01.04.2025.
//

import SwiftUI

struct AdviceView: View {
    @EnvironmentObject var db: AppData
    @State var previewPressed:[PromtOpenAI.Advice.RetriveTitles] = []
    @ObservedObject var viewModel:AdviceViewModel = .init()
    init(document: Document? = nil) {
        viewModel.document = document
    }
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing:0) {
                PDFKitView(pdfData: viewModel.document?.data)
                .frame(width: db.deviceSize.width - (db.deviceSize.width / 10))
                .padding(.top, !hasNotDetectedData ? 0 : 50)
                .overlay {
                    VStack {
                        self.retrivedContent.frame(height:!hasNotDetectedData ? 0 : 50)
                            .clipped()
                        Spacer()
                    }
                }
                ScrollView(.vertical, showsIndicators: false, content: {
                    rightControlView
                        .frame(width: db.deviceSize.width - (db.deviceSize.width / 10))
                })
                .background {
                    ClearBackgroundView()
                }
                
            }
            .background(.brown)
            .background {
                ClearBackgroundView()
            }
            .frame(maxHeight: .infinity)
        }
        .background {
            ClearBackgroundView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    var hasNotDetectedData:Bool {
        let cvContent = viewModel.document?.request?.advice?.allValues ?? [:]
        return cvContent.contains { (key: PromtOpenAI.Advice.RetriveTitles, value: String) in
            return key.openAIUsed && value.isEmpty
        }
    }
    
    var retrivedContent: some View {
        let cvContent = viewModel.document?.request?.advice?.allValues ?? [:]
        return ScrollView(.horizontal, content: {
            HStack {
                ForEach(cvContent.keys.sorted(by: {$0.rawValue >= $1.rawValue}).filter({$0.openAIUsed}).compactMap({$0.rawValue}), id:\.self) { item in
                    if (cvContent[.init(rawValue: item) ?? .contacts] ?? "").isEmpty {
                        VStack {
                            HStack {
                                Text((PromtOpenAI.Advice.RetriveTitles.init(rawValue: item) ?? .contacts).rawValue.addSpaceBeforeCapitalizedLetters.capitalized)
                                Spacer()
                                Text((cvContent[.init(rawValue: item) ?? .contacts] ?? "").isEmpty ? "not detected" : "detected")
                            }
        //                    Button {
        //                        let key = PromtOpenAI.Advice.RetriveTitles.init(rawValue: item) ?? .contacts
        //                        if previewPressed.contains(key) {
        //                            withAnimation {
        //                                previewPressed.removeAll(where: {
        //                                    $0.rawValue == key.rawValue
        //                                })
        //                            }
        //                        } else {
        //                            withAnimation {
        //                                previewPressed.append(key)
        //                            }
        //                        }
        //                    } label: {
        //                        HStack {
        //                            Text((PromtOpenAI.Advice.RetriveTitles.init(rawValue: item) ?? .contacts).rawValue.addSpaceBeforeCapitalizedLetters.capitalized)
        //                            Spacer()
        //                            Text((cvContent[.init(rawValue: item) ?? .contacts] ?? "").isEmpty ? "not detected" : "detected")
        //                        }
        //                    }
        //
        //                    Text(cvContent[.init(rawValue: item) ?? .contacts] ?? "")
        //                        .lineLimit(previewPressed.contains(.init(rawValue: item) ?? .contacts) ? nil : 1)
                        }
                    }
                    
                }
            }
        })
        .padding(10)
        .background(.red)
        .padding(5)
    }
    
    var request: some View {
        VStack {
            if let content = viewModel.document?.response {
                ForEach(PromtOpenAI.Advice.Keys.allCases, id:\.rawValue) { key in
                    VStack {
                        Text(key.title)
                        Text(content.value(for: key))
                    }
                }
            }
        }
    }
    
    var rightControlView: some View {
        VStack {
            TextField("Job title", text: .init(get: {
                viewModel.document?.request?.advice?.allValues[.jobTitle] ?? ""
            }, set: {
                var advice = viewModel.document?.request?.advice ?? .init([:])
                advice.dict.updateValue($0, forKey: PromtOpenAI.Advice.RetriveTitles.jobTitle.rawValue)
                viewModel.document?.request = .advice(advice)
            }))
            request
            Button("generate") {
                viewModel.generatePressed(completion: {
                    if let document = viewModel.document {
                        self.db.db.documents.update(document)

                    }
                })
            }
            .disabled(viewModel.isLoading)
        }
    }
}
