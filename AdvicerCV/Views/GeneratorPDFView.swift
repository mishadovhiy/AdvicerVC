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
    var body: some View {
        VStack {
            AttributedTextView(attributedString: self.viewModel.attrubute, didPressLink: { link, at in
                viewModel.linkSelected = (link, at)
            })
            .frame(maxHeight: .infinity)
            ScrollView {
                VStack {
                    Spacer()
                    Button("export") {
                        viewModel.exportPressed()
                    }.frame(height: 44)
                }
            }
            .frame(maxHeight: .infinity)
        }
        .sheet(isPresented: $viewModel.isExportPresenting) {
            ActivityViewController(activityItems: [viewModel.exportingURL ?? .init(string: "https://mishadovhiy.com")!])
        }
        .onAppear {
            viewModel.cvContent = .mock
        }
    }


}

#Preview {
    GeneratorPDFView()
}
