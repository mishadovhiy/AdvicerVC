//
//  AdviceView.swift
//  AdvicerCV
//
//  Created by Mykhailo Dovhyi on 01.04.2025.
//

import SwiftUI


struct AdviceView: View {
    @EnvironmentObject var db: AppData
    @State var previewPressed:[NetworkRequest.Advice.RetriveTitles] = []
    @ObservedObject var viewModel:AdviceViewModel = .init()

    init(document: Document? = nil) {
        viewModel.document = document
    }
    
    @State var jobTitleText = "" {
        didSet {
            print("getfrsda ", jobTitleText)
        }
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
        .onAppear {
            jobTitleText = viewModel.document?.request?.advice?.text(for: .jobTitle) ?? "??????"
            print("settingjobtrte")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    var hasNotDetectedData:Bool {
        let cvContent = viewModel.document?.request?.advice?.allValues ?? [:]
        return cvContent.contains { (key: NetworkRequest.Advice.RetriveTitles, value: String) in
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
                                Text((NetworkRequest.Advice.RetriveTitles.init(rawValue: item) ?? .contacts).rawValue.addSpaceBeforeCapitalizedLetters.capitalized)
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
                ForEach(NetworkRequest.Advice.Keys.allCases, id:\.rawValue) { key in
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
            TextField("Job title", text: $jobTitleText) { editing in
                if !editing {
                    viewModel.doneEditingJobTitle(&db.db, newValue: jobTitleText)
                }
            }
            request
            Button("Generate") {
                viewModel.generatePressed(completion: {
                    if let document = viewModel.document {
                        self.db.db.documents.update(document)
                        print(document.response?.value(for: .atsGrade), " fdgfdsg ")
                        viewModel.document = db.db.documents.first(where: {
                            self.viewModel.document?.id == $0.id
                        })
                        print(viewModel.document?.response?.value(for: .atsGrade), " gfhddfgd ")

                    }
                })
            }
            .disabled(viewModel.isLoading)
        }
    }
}
