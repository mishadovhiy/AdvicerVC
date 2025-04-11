//
//  GeneratorPDFView.swift
//  AdvicerCV
//
//  Created by Mykhailo Dovhyi on 02.04.2025.
//

import SwiftUI
import UIKit

struct GeneratorPDFView: View {
    @State var viewModel = GeneratorPDFViewModel()
    @State var generalColorsPresenting = false
    @State var generalFontsPresenting = false
    @State var generalSpacesPresenting = false
    var editorNavigationPushed:Bool {
        [generalColorsPresenting, generalFontsPresenting].contains(true)
    }
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                AttributedTextView(attributedString: self.viewModel.attrubute, didPressLink: { link, at in
                    viewModel.linkSelected(link)
                })
                .padding(.horizontal, 10)
                .frame(width: PDFGeneratorModel.pdfWidth)
                .frame(maxHeight: .infinity)
                .background(.white)
            }
            generalEditor
        }
        .sheet(isPresented: $viewModel.isExportPresenting) {
            ActivityViewController(activityItems: [viewModel.exportingURL ?? .init(string: "https://mishadovhiy.com")!])
        }
        .onAppear {
            viewModel.cvContent = .mock
        }
    }

    var workExperienceEditor: some View {
        let key = viewModel.editingPropertyKey
        let ignoreDescription = [key == .jobTitle, key == .cvDescriptionTitle]
        let ignoreSpace = [key == .jobTitle, key == .cvDescriptionTitle]
        let ignoreText = [key == .jobTitle, key == .cvDescriptionTitle]
        let ignoreBold = [key == .jobTitle, key == .cvDescriptionTitle]
        let ignoreTitle = [key == .summary]
        return VStack {
            //date
            if !ignoreTitle.contains(true) {
                TextField("title:", text: $viewModel.editingPropertyTitle)
                    .foregroundColor(.white)
            }
            if !ignoreDescription.contains(true) {
                TextField("description:", text: $viewModel.editingPropertyTitleDescription)
                    .foregroundColor(.white)

            }
//            if !ignoreSpace.contains(true) {
//                Toggle("Need left space", isOn: $viewModel.editingNeedLeftSpace)
//                    .foregroundColor(.white)
//
//            }
            if !ignoreText.contains(true) {
                TextEditor(text: $viewModel.editingPropertyText)
                    .padding(0)
                    .foregroundColor(.white)
                    .background(.red)
                    .frame(maxWidth:.infinity)
                    .frame(height:120)
                    .overlay {
                        VStack {
                            HStack {
                                Text("Start typing")
                                    .foregroundColor(.white)
                                    .opacity(0.15)
                                Spacer()
                            }
                                
                            Spacer()
                        }
                        .padding(10)
                        .opacity(viewModel.editingPropertyText.isEmpty ? 1 : 0)
                        .disabled(true)
                    }
            }
            if key?.needDates ?? false {
                DatePicker("Date From", selection: $viewModel.editingDateFrom, displayedComponents: [.date])
                    .foregroundColor(.white)

                    .datePickerStyle(.compact)
                DatePicker("Date To", selection: $viewModel.editingDateTo, displayedComponents: [.date])
                    .datePickerStyle(.compact)
                    .foregroundColor(.white)
            }
            if !ignoreBold.contains(true) {
                TextField("Bold text", text: $viewModel.editingboldTexts)
                    .foregroundColor(.white)
            }
            
        }
        .toolbar {
#if os(watchOS)
#else
            ToolbarItemGroup(placement: .keyboard) {
                
                Button {
                    endEditingKeyboard()
                } label: {
                    Text("Close")
                }
                Spacer()
            }
#endif
        }
        .padding(10)
        .background(.black)
        .cornerRadius(6)

        .padding(.horizontal, 10)
        .navigationTitle(viewModel.editingPropertyKey?.titles.first ?? "?")
        .navigationBarItems(trailing: HStack {
            Button("delete") {
                viewModel.deleteSelectedItemPressed()
            }
        })
    }

    var valueEditorView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                if let id = viewModel.editingWorkExperience {
                    self.workExperienceEditor
                }
            }
            
        }.background(.red)


    }
    
    var generalEditor: some View {
        NavigationView {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    NavigationLink(destination:

                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(GeneratorPDFViewModel.ContentType.allCases, id:\.self) { type in
                                    NavigationLink(type.title, destination: ColorPicker(type.title, selection: $viewModel.selectingColorType).background(.red), isActive: .init(get: {
                                        viewModel.colorSelectingFor == type
                                    }, set: { newValue in
                                        viewModel.colorSelectingFor = newValue ? type : nil
                                    }))
                                }
                            }
                        }
                        .background(.red)
                    , isActive: $generalColorsPresenting) {
                        Text("Colors")
                    }
                    NavigationLink(destination: HStack {
                        Text("color")
                        Text("color")
                        Text("color")
                        Text("color")
                        Text("color")
                        Text("color")
                        Text("color")
                        Text("color")
                    }, isActive: $generalFontsPresenting) {
                        Text("Fonts")
                    }
//                    NavigationLink(destination: HStack {
//                        Text("color")
//                        Text("color")
//                        Text("color")
//                        Text("color")
//                        Text("color")
//                        Text("color")
//                        Text("color")
//                        Text("color")
//                    }, isActive: $generalSpacesPresenting) {
//                        Text("Spaces")
//                    }

                    
                    Button("export") {
                        viewModel.exportPressed()
                    }
                    
                    NavigationLink("", destination: valueEditorView, isActive: $viewModel.isPresentingValueEditor)
                        .hidden()
                }
            }
            .background {
                ClearBackgroundView()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .background {
            ClearBackgroundView()
        }
        .frame(maxHeight: viewModel.largeEditorHeight ? .infinity : (editorNavigationPushed ? 70 : 45))

        .animation(.smooth, value: viewModel.isPresentingValueEditor)

    }

}

#Preview {
    GeneratorPDFView()
}
