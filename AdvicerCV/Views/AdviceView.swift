//
//  AdviceView.swift
//  AdvicerCV
//
//  Created by Mykhailo Dovhyi on 01.04.2025.
//

import SwiftUI


struct AdviceView: View {
    @Binding var document:Document?
    @State var isLoading:Bool = false
    @State var documentReloadID:UUID = .init()
    
    @EnvironmentObject var db: AppData
    @State var previewPressed:[NetworkRequest.Advice.RetriveTitles] = []
    
    @State var jobTitleText = ""
    @State var deleteDocumentConfirmationPresenting = false
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing:0) {
                PDFKitView(pdfData: document?.data)
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
            .background(HomeViewModel.PresentingTab.advices.color)
            .background {
                ClearBackgroundView()
            }
            .frame(maxHeight: .infinity)
        }
        .confirmationDialog("Are you sure you want to delete a document?", isPresented: $deleteDocumentConfirmationPresenting, actions: {
            Button("Yes") {
                deleteDocumentConfirmationPresenting = false
                db.db.documents.removeAll { doc in
                    doc.id == self.document?.id
                }
                document = nil
            }
            Button("Cancel") {
                deleteDocumentConfirmationPresenting = false

            }
        })
        .background {
            ClearBackgroundView()
        }
        .onAppear {
//            viewModel.document = initialDocument
            jobTitleText = document?.request?.advice?.text(for: .jobTitle) ?? "??????"
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    var hasNotDetectedData:Bool {
        let cvContent = document?.request?.advice?.allValues ?? [:]
        return cvContent.contains { (key: NetworkRequest.Advice.RetriveTitles, value: String) in
            return key.openAIUsed && value.isEmpty
        }
    }
    
    var retrivedContent: some View {
        let cvContent = document?.request?.advice?.allValues ?? [:]
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
            if let content = document?.response {
                ForEach(NetworkRequest.Advice.Keys.allCases, id:\.rawValue) { key in
                    VStack {
                        Text(key.title)
                        Text(content.value(for: key))
                    }
                }
            }
        }
        .id(documentReloadID)
    }

    var rightControlView: some View {
        VStack {
            TextField("Job title", text: $jobTitleText) { editing in
                if !editing {
                    doneEditingJobTitle(&db.db, newValue: jobTitleText)
                }
            }
            request
            Button("Generate") {
                generatePressed(completion: {
                    if let document = document {
                        self.db.db.documents.update(document)
                        print(document.response?.value(for: .atsGrade), " fdgfdsg ")
                        self.document = db.db.documents.first(where: {
                            self.document?.id == $0.id
                        })
                        print(document.response?.value(for: .atsGrade), " gfhddfgd ")

                    }
                })
            }
            .disabled(isLoading)
        }
    }
}

extension AdviceView {
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
                        self.documentReloadID = .init()
                        completion()
                    }
                }
            }
        }
        
    }
}
