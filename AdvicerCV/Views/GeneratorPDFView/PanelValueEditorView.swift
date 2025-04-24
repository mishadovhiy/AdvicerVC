//
//  PanelValueEditor.swift
//  AdvicerCV
//
//  Created by Mykhailo Dovhyi on 24.04.2025.
//

import SwiftUI

struct PanelValueEditorView: View {
    @Binding var viewModel:GeneratorPDFViewModel
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                if viewModel.editingWorkExperience != nil {
                    self.valueEditor
                }
            }
        }
        .background {
            ClearBackgroundView()
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Button {
                    endEditingKeyboard()
                } label: {
                    Text("Close")
                }
                Spacer()
            }
        }
        .navigationTitle(viewModel.editingPropertyKey?.titles.first ?? "?")
    }
    
    var valueEditor: some View {
        let key = viewModel.editingPropertyKey
        let ignoreBold = [key == .jobTitle, key == .cvDescriptionTitle]
        let ignoreTitle = [key == .summary]
        return VStack {
            if !ignoreTitle.contains(true) {
                TextField("title:", text: $viewModel.editingPropertyTitle)
                    .foregroundColor(.white)
            }
            if key?.needDescription ?? false {
                TextField("description:", text: $viewModel.editingPropertyTitleDescription)
                    .foregroundColor(.white)
                
            }
            if key?.needLargeText ?? false {
                self.textEditor
                
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
        .padding(10)
        .background(.black.opacity(0.2))
        .cornerRadius(6)
        .padding(.horizontal, 10)
        .navigationBarItems(trailing: HStack {
            if key?.canDelete ?? false {
                Button("delete") {
                    viewModel.deleteSelectedItemPressed()
                }
            }
        })
    }
    
    var textView: some View {
        if #available(iOS 16.0, *) {
            return TextEditor(text: $viewModel.editingPropertyText)
                .scrollContentBackground(.hidden)
        } else {
            return TextEditor(text: $viewModel.editingPropertyText)
        }
    }
    
    var textEditor: some View {
        self.textView
            .padding(0)
            .foregroundColor(.white)
            .frame(maxWidth:.infinity)
            .frame(height:120)
            .background(content: {
                ClearBackgroundView()
            })
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
}


