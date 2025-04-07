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
        VStack {
            //date
            TextField("title:", text: $viewModel.editingPropertyTitle)
            TextField("description:", text: $viewModel.editingPropertyTitleDescription)
            Toggle("Need left space", isOn: $viewModel.editingNeedLeftSpace)
            TextField("Text", text: $viewModel.editingPropertyText)
            TextField("Bold text", text: $viewModel.editingboldTexts)

            RoundedRectangle(cornerRadius: 12)
                .fill(.orange)
                .frame(height: 1000)
            
        }
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
            .opacity(0.2)
            
        }


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
                    NavigationLink(destination: HStack {
                        Text("color")
                        Text("color")
                        Text("color")
                        Text("color")
                        Text("color")
                        Text("color")
                        Text("color")
                        Text("color")
                    }, isActive: $generalSpacesPresenting) {
                        Text("Spaces")
                    }

                    
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
        .frame(maxHeight: viewModel.largeEditorHeight ? .infinity : (generalColorsPresenting ? 60 : 45))
        .animation(.smooth, value: viewModel.isPresentingValueEditor)

    }

}

#Preview {
    GeneratorPDFView()
}
