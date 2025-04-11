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
        VStack(spacing:-10) {
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
        .background(.black.opacity(0.2))
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
            
        }
        .background {
            ClearBackgroundView()
        }

    }
    
    var fontButton: some View {
        NavigationLink(destination: ScrollView(.horizontal, content: {
            HStack {
                Text("color")
                Text("color")
                Text("color")
                Text("color")
                Text("color")
                Text("color")
                Text("color")
                Text("color")
            }
            .padding(.horizontal, 15)
        })
            .background {
                ClearBackgroundView()
            }, isActive: $generalFontsPresenting) {
                Image(.font)
                    .resizable()
                    .foregroundColor(.white)
                    .tint(.white)
                    .scaledToFit()
                    .frame(width:30)
                    .aspectRatio(1, contentMode: .fit)
        }
            .tint(.white)
    }
    
    var colorButton: some View {
        NavigationLink(destination:
            ScrollView(.horizontal) {
                HStack {
                    ForEach(GeneratorPDFViewModel.ContentType.allCases, id:\.self) { type in
                        NavigationLink(type.title, destination: ColorPicker(type.title, selection: $viewModel.selectingColorType).background(.red), isActive: .init(get: {
                            viewModel.colorSelectingFor == type
                        }, set: { newValue in
                            withAnimation {
                                viewModel.colorSelectingFor = newValue ? type : nil
                            }
                        }))
                    }
                }
                .padding(.horizontal, 15)

            }
            .background {
                ClearBackgroundView()
            }
        , isActive: $generalColorsPresenting) {
            Image(.color)
                .resizable()
                .foregroundColor(.white)
                .tint(.white)
                .scaledToFit()
                .frame(width:30)
                .aspectRatio(1, contentMode: .fit)
        }
    }
    
    var generalEditor: some View {
        NavigationView {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing:20) {
                    colorButton
                    Divider()
                    fontButton
                    Divider()
                    Button("export") {
                        viewModel.exportPressed()
                    }
                    .padding(.vertical, 5)
                    .padding(.horizontal, 20)
                    .background(.white)
                    .cornerRadius(6)
                    NavigationLink("", destination: valueEditorView, isActive: $viewModel.isPresentingValueEditor)
                        .hidden()
                }
                .padding(.horizontal, 20)
                .background {
                    ClearBackgroundView()
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
        .frame(maxHeight: viewModel.largeEditorHeight ? .infinity : (editorNavigationPushed ? 90 : 45))
        .background(content: {
            Color(.red)
                .padding(.vertical, -20)
                .cornerRadius(12)
        })
        .animation(.smooth, value: viewModel.isPresentingValueEditor)

    }

}

#Preview {
    GeneratorPDFView()
}
