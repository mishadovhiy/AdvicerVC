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
                    Spacer().frame(width: 10)
                    colorButton
                        .tint(.white)
                    Divider()
                    fontButton
                        .tint(.white)
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
        .frame(maxHeight: isPresenting ? (viewModel.largeEditorHeight ? .infinity : (viewModel.editorNavigationPushed ? (viewModel.generalColorsPresenting ? 170 : 110) : 60)) : 0)
        .background(content: {
            Color(.purple)
                .padding(.vertical, -20)
                .cornerRadius(20)
        })
        .shadow(radius: 20)
        .animation(.smooth, value: viewModel.isPresentingValueEditor)
    }
    
    
    func fontTypeDestination(_ type:GeneratorPDFViewModel.ContentType) -> some View {
        VStack {
            HStack(spacing:15) {
                Button("-1") {
                    viewModel.selectingFontSize -= 1
                }
                .tint(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(.black.opacity(0.1))
                .cornerRadius(4)
                HStack {
                    Text("Font size")
                        .foregroundColor(.white)
                    Text("\(Int(viewModel.selectingFontSize))")
                        .foregroundColor(.white)
                        .font(.system(size: 15, weight:.semibold))
                }
                Button("+1") {
                    viewModel.selectingFontSize += 1
                }
                .tint(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(.black.opacity(0.1))
                .cornerRadius(4)
            }
            Divider()
            fontWeight(type)
        }
        .background {
            ClearBackgroundView()
        }
        .navigationTitle(type.title)
    }
    
    func fontTypeLink(_ type:GeneratorPDFViewModel.ContentType) -> some View {
        NavigationLink(destination: fontTypeDestination(type), isActive: .init(get: {
            viewModel.fontSelectingFor == type
        }, set: { newValue in
            withAnimation {
                viewModel.fontSelectingFor = newValue ? type : nil
            }
        })) {
            Text(type.title)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.darkBlue)
                .padding(.horizontal, 25)
                .padding(.vertical, 7)
                .background(.lightBlue)
                .cornerRadius(4)
        }
    }
    
    var fontButton: some View {
        NavigationLink(destination: ScrollView(.horizontal, showsIndicators: false, content: {
            HStack {
                ForEach(GeneratorPDFViewModel.ContentType.allCases, id:\.self) { type in
                    fontTypeLink(type)
                }
            }
            .padding(.horizontal, 15)
            .padding(.bottom, 15)
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
        .tint(.white)
        .foregroundColor(.white)
    }
    
    var colorButton: some View {
        NavigationLink(destination:
                        VStack(content: {
            Spacer().frame(height: 1)
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    ForEach(GeneratorPDFViewModel.ContentType.allCases, id:\.self) { type in
                        colorPicker(type)
                    }
                }
                .padding(.bottom, 30)
                
                .padding(.horizontal, 15)
            }
        })
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
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(UIFont.Weight.allCases, id:\.rawValue) { font in
                    Button {
                        withAnimation {
                            viewModel.selectingFontWeight = font
                        }
                    } label: {
                        Text(font.string)
                            .font(.system(size: 12, weight:.semibold))
                            .foregroundColor(font == viewModel.selectingFontWeight ? .black : .white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 3)
                            .background(font == viewModel.selectingFontWeight ? .white : .gray)
                            .cornerRadius(4)
                            .animation(.smooth, value: viewModel.selectingFontWeight)
                    }

                    
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
        }
        
    }
    
    
}

