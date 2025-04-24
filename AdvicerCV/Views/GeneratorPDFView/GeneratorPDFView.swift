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
    @EnvironmentObject var db:AppData
    @Binding var isPresenting:Bool
    
    var body: some View {
        VStack(spacing:-20) {
            ScrollView(.horizontal) {
                AttributedTextView(attributedString: self.viewModel.attrubute, didPressLink: { link, at in
                    viewModel.linkSelected(link)
                })
                .padding(.horizontal, 10)
                .padding(.bottom, 20)
                .frame(width: PDFGeneratorModel.pdfWidth)
                .frame(maxHeight: .infinity)
                .background(.white)
            }
            BottomGeneratorPanelView(viewModel: $viewModel, isPresenting: $isPresenting)
        }
        .sheet(isPresented: $viewModel.isExportPresenting) {
            ActivityViewController(activityItems: [viewModel.exportingURL ?? .init(string: "https://mishadovhiy.com")!])
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                viewModel.cvContent = db.db.generatorContent.content
                viewModel.appearence = db.db.generatorContent.apperance
            })

        }
    }


}

