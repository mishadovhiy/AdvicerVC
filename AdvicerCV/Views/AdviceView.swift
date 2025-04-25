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
                    .padding(.leading, -10)
                    .padding(.trailing, -10)
                    .padding(.top, -10)
                    .padding(.bottom, -10)
                    .cornerRadius(20)
                .frame(width: db.deviceSize.width - (db.deviceSize.width / 5))
                .padding(.top, !hasNotDetectedData ? 20 : 60)
                .padding(.leading, 20)
                .padding(.bottom, 20)

                .overlay {
                    VStack {
                        self.retrivedContent.frame(height:!hasNotDetectedData ? 0 : 50)
                            .clipped()
                        Spacer()
                    }
                }
                rightContent
                
            }
            .background(HomeViewModel.PresentingTab.advices.color)
//            .background(.white)
            .background {
                ClearBackgroundView()
            }
            .frame(maxHeight: .infinity)
            .overlay {
                VStack {
                    HStack {
                        Button("Back") {
                            self.document = nil
                        }
                        .tint(.darkBlue)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(.primaryText)
                        .cornerRadius(4)
                        .shadow(radius: 5)
                        Spacer()
                    }
                    Spacer()
                }
                .padding(15)
            }

        }
        .navigationBarHidden(true)
        
        .confirmationDialog("Are you sure you want to delete a document?", isPresented: $deleteDocumentConfirmationPresenting, actions: {
            Button("Yes") {
                deleteDocumentConfirmationPresenting = false
                db.db.documents.removeAll { doc in
                    doc.id == self.document?.id
                }
                withAnimation {
                    document = nil
                }
            }
            Button("Cancel") {
                deleteDocumentConfirmationPresenting = false

            }
        }, message: {
            Text("Are you sure you want to delete a document?")
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
    
    var requestInputView: some View {
        VStack {
            Spacer().frame(height: 50)
            HStack {
                TextField("Job title",
                          text: $jobTitleText,
                          prompt: Text("Job title").foregroundColor(.white.opacity(0.3)))
                .onSubmit {
                    doneEditingJobTitle(&db.db, newValue: jobTitleText)
                }
                .foregroundColor(.primaryText)
                Button("Delete") {
                    self.deleteDocumentConfirmationPresenting = true
                }
                .tint(.red)
                .padding(5)
                .background(.red.opacity(0.15))
                .cornerRadius(4)
            }
            Spacer().frame(height:30)
        }
        .padding(.leading, 20)
        .padding(.trailing, 10)
        .background {
            HomeViewModel.PresentingTab.advices.color
                .cornerRadius(30)
                .padding(.top, -60)
        }
    }
    
    var generateButton: some View {
        HStack {
            Spacer()
            Button(((document?.response != nil) ? "Re-" : "") + "Generate") {
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
            .tint(.white)
            .font(.system(size: 15, weight:.semibold))
            .padding(.vertical, 6)
            .padding(.horizontal, 20)
            .background(HomeViewModel.PresentingTab.advices.color)
            .cornerRadius(6)
            .disabled(isLoading || jobTitleText.isEmpty)
        }
        .padding(.bottom, 10)
        .padding(.trailing, 20)

    }
    
    var rightContent: some View {
        VStack {
            requestInputView
            ScrollView(.vertical, showsIndicators: false, content: {
                rightControlView
                    .frame(width: db.deviceSize.width - (db.deviceSize.width / 5))
                    .frame(minHeight: 300)
                    .padding(10)
                    .background {
                        lightBackgroundView
                    }
                    .clipped()
            })
            .background {
                lightBackgroundView
            }
            .cornerRadius(30)
            .background(content: {
                VStack {
                    Spacer().frame(maxHeight: .infinity)
                    Color.white
                        .padding(.bottom, -400)
                }
            })
            .padding(.leading, 20)
        }
        .background(
            Color.white.padding(.leading,100)
                .padding(.trailing, -500)
        )
        .overlay {
            VStack {
                Spacer()
                generateButton
            }
        }
    }
    
    
    var lightBackgroundView: some View {
        Color.white
            .cornerRadius(35)
            .padding(.trailing,-35)
            .padding(.bottom, -135)
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
        .padding(5)
    }
    
    
    
    var response: some View {
        VStack(alignment:.leading, spacing:15) {
            Spacer().frame(height: 20)
            if let content = document?.response {
                ForEach(NetworkRequest.Advice.Keys.allCases, id:\.rawValue) { key in
                    VStack(alignment:.leading) {
                        Text(key.title)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.darkBlue)
                        if key.rawValue.uppercased().contains("grade".uppercased()),
                           let int = content.value(for: key).number
                        {
                            HStack {
                                ForEach(0..<5, id:\.self) { i in
                                    Image(.star)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width:10, height:10)
                                        .foregroundColor(i < int ? .yellow : .gray)
                                }
                            }
                        } else {
                            Text(content.value(for: key))
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.darkText)
                        }
                        
                        Divider()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            } else {
                noResponse
            }
            Spacer().frame(height: 30)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    var rightControlView: some View {
        VStack {
            response
            Spacer()
        }
    }
    
    var noResponse: some View {
        VStack {
            Spacer().frame(height: 80)
            Image(.noAIResponse)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 190)
            Spacer().frame(height: 50)
            VStack {
                Text("Start generating CV Advice")
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.darkBlue)
                Spacer().frame(height: 10)
                VStack(alignment:.leading) {
                    Text("AI Generation based on:")
                        .font(.system(size: 13, weight:.semibold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.darkText)
                    VStack(alignment:.leading) {
                        ForEach(NetworkRequest.Advice.RetriveTitles.allCases.filter({$0.openAIUsed}), id:\.rawValue) { key in
                            Text("- " + (key.titles.first ?? "-"))
                                .font(.system(size: 13))
                                .frame(alignment: .leading)
                                .multilineTextAlignment(.leading)
                                .foregroundColor(.darkText)
                            Spacer().frame(height: 2)

                        }
                    }
                }
            }
            .frame(maxWidth:300)
            .padding(.horizontal, 5)
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
