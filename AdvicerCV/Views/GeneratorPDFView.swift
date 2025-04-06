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
            AttributedTextView(attributedString: self.viewModel.attrubute, didPressLink: { link, at in
                viewModel.linkSelected = (link, at)
                if let key = GeneratorPDFViewModel.CVContent.Key.allCases.first(where: {
                    link.lowercased().contains($0.rawValue.lowercased())
                    
                }) {
                    viewModel.editingPropertyKey = key
                    let id = link.lowercased().replacingOccurrences(of: key.rawValue.lowercased(), with: "")
                    print(id, "ythrgtfd")
                    if id.isEmpty {
                        withAnimation {
                            self.viewModel.editingWorkExperience = .init()
                            self.viewModel.cvContent.workExperience.append(.init(from: .now, id: self.viewModel.editingWorkExperience!))
                        }
                    } else {
                        withAnimation {
                            self.viewModel.editingWorkExperience = .init(uuidString: id)
                        }
                    }
                }

            })
            .frame(maxHeight: .infinity)
            generalEditor
        }
        .sheet(isPresented: $viewModel.isExportPresenting) {
            ActivityViewController(activityItems: [viewModel.exportingURL ?? .init(string: "https://mishadovhiy.com")!])
        }
        .onAppear {
            viewModel.cvContent = .mock
        }
        .background(.black)
    }

    var workExperienceEditor: some View {
        VStack {
            //date
            TextField("title:", text: $viewModel.editingPropertyTitle)
            TextField("description:", text: $viewModel.editingPropertyTitleDescription)
            Toggle("Need left space", isOn: $viewModel.editingNeedLeftSpace)
            TextField("Text", text: $viewModel.editingPropertyText)

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
            ScrollView(.horizontal) {
                HStack {
                    NavigationLink(destination: HStack {
                        Text("color")
                        Text("color")
                        Text("color")
                        Text("color")
                        Text("color")
                        Text("color")
                        Text("color")
                        Text("color")
                    }, isActive: $generalColorsPresenting) {
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
                    
                    Text("sdfdsf")
                    Text("sdfdsf")

                    Text("sdfdsf")

                    Text("sdfdsf")
                    
                    Button("export") {
                        viewModel.exportPressed()
                    }
                    .background(.red)
                    
                    NavigationLink("", destination: valueEditorView, isActive: $viewModel.isPresentingValueEditor)
                        .hidden()
                }
            }
            .background(.red)
        }
        .frame(maxHeight: viewModel.isPresentingValueEditor ? .infinity : 45)
        .animation(.smooth, value: viewModel.isPresentingValueEditor)
        .background {
            ClearBackgroundView()
        }
    }

}

#Preview {
    GeneratorPDFView()
}
