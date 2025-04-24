//
//  BottomGeneratorPanelView.swift
//  AdvicerCV
//
//  Created by Mykhailo Dovhyi on 23.04.2025.
//

import SwiftUI

struct BottomGeneratorPanelView: View {
    @Binding var viewModel:GeneratorPDFViewModel
    @Binding var isPresenting:Bool
    
    var body: some View {
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
                    NavigationLink("", destination: PanelValueEditorView(viewModel: $viewModel), isActive: $viewModel.isPresentingValueEditor)
                        .hidden()
                }
                .padding(.horizontal, 20)
                .background {
                    ClearBackgroundView()
                }
            }
            .navigationBarHidden(true)
            .background {
                ClearBackgroundView()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .background {
            ClearBackgroundView()
        }
        .frame(maxHeight: isPresenting ? (viewModel.largeEditorHeight ? 160 : (viewModel.editorNavigationPushed ? 120 : 45)) : 0)
        .background(content: {
            Color(.red)
                .padding(.vertical, -20)
                .cornerRadius(12)
        })
        .animation(.smooth, value: viewModel.isPresentingValueEditor)
    }
    
    
    func fontTypeLink(_ type:GeneratorPDFViewModel.ContentType) -> some View {
        NavigationLink(type.title, destination: VStack {
            Text("size")
            Slider(value: $viewModel.selectingFontSize)
            Divider()
            selectingFont(type)
        }.background {
            ClearBackgroundView()
        }, isActive: .init(get: {
            viewModel.fontSelectingFor == type
        }, set: { newValue in
            withAnimation {
                viewModel.fontSelectingFor = newValue ? type : nil
            }
        }))
    }
    
    var fontButton: some View {
        NavigationLink(destination: ScrollView(.horizontal, content: {
            HStack {
                ForEach(GeneratorPDFViewModel.ContentType.allCases, id:\.self) { type in
                    fontTypeLink(type)
                }
            }
            .padding(.horizontal, 15)
        })
            .background {
                ClearBackgroundView()
            }, isActive: $viewModel.generalFontsPresenting) {
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
    
    func colorPicker(_ type:GeneratorPDFViewModel.ContentType) -> some View {
        ColorPicker(type.title, selection: .init(get: {
            .init(uiColor: .init(hex: viewModel.appearence.color[type] ?? "") ?? .pdfText)

        }, set: {
            viewModel.appearence.color[type] = UIColor(cgColor: $0.cgColor ?? UIColor.white.cgColor).toHex
        }))
    }
    
    var colorButton: some View {
        NavigationLink(destination:
                        ScrollView(.vertical) {
            VStack {
                ForEach(GeneratorPDFViewModel.ContentType.allCases, id:\.self) { type in
                    colorPicker(type)
                }
            }
            .padding(.horizontal, 15)
        }
            .frame(maxHeight: .infinity)
            .background {
                ClearBackgroundView()
            }, isActive: $viewModel.generalColorsPresenting) {
            Image(.color)
                .resizable()
                .foregroundColor(.white)
                .tint(.white)
                .scaledToFit()
                .frame(width:30)
                .aspectRatio(1, contentMode: .fit)
        }
    }
    
    func selectingFont(_ type:GeneratorPDFViewModel.ContentType) -> some View {
        Picker("Weight", selection: $viewModel.selectingFontWeight) {
            ForEach(UIFont.Weight.allCases, id:\.string) { font in
                Text(font.string)
                    .id(UIFont.Weight.allCases.firstIndex(where: {
                        $0 == font
                    }) ?? 0)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        
    }
    
    
}

