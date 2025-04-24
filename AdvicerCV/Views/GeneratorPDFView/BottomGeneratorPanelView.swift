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
        .frame(maxHeight: isPresenting ? (viewModel.largeEditorHeight ? 160 : (viewModel.editorNavigationPushed ? 120 : 60)) : 0)
        .background(content: {
            Color(.darkBlue)
                .padding(.vertical, -20)
                .cornerRadius(20)
        })
        .shadow(radius: 20)
        .animation(.smooth, value: viewModel.isPresentingValueEditor)
    }
    
    
    func fontTypeLink(_ type:GeneratorPDFViewModel.ContentType) -> some View {
        NavigationLink(type.title, destination: VStack {
            HStack(spacing:15) {
                Button("-1") {
                    viewModel.selectingFontSize -= 1
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(.black.opacity(0.1))
                .cornerRadius(4)
                HStack {
                    Text("Font size")

                    Text("\(Int(viewModel.selectingFontSize))")
                }
                Button("+1") {
                    viewModel.selectingFontSize += 1
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(.black.opacity(0.1))
                .cornerRadius(4)
            }
            Divider()
            fontWeight(type)
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
            .padding(15)
        })
            .background {
                ClearBackgroundView()
            }, isActive: .init(get: {
                viewModel.generalFontsPresenting
            }, set: { newValue in
                withAnimation {
                    viewModel.generalFontsPresenting = newValue
                }
            })) {
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
            }, isActive: .init(get: {
                viewModel.generalColorsPresenting
            }, set: { newValue in
                withAnimation {
                    viewModel.generalColorsPresenting = newValue
                }
            })) {
            Image(.color)
                .resizable()
                .foregroundColor(.white)
                .tint(.white)
                .scaledToFit()
                .frame(width:30)
                .aspectRatio(1, contentMode: .fit)
        }
    }
    
    func fontWeight(_ type:GeneratorPDFViewModel.ContentType) -> some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(UIFont.Weight.allCases, id:\.rawValue) { font in
                    Text(font.string)
                        .font(.system(size: 12, weight:.semibold))
                        .foregroundColor(font == viewModel.selectingFontWeight ? .black : .white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 3)
                        .background(font == viewModel.selectingFontWeight ? .white : .gray)
                        .cornerRadius(4)
                    
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
        }
        
    }
    
    
}

