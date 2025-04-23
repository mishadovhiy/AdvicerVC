//
//  PrivacyPolicyView.swift
//  AdvicerCV
//
//  Created by Mykhailo Dovhyi on 23.04.2025.
//

import SwiftUI

struct PrivacyPolicyView: View {
    @Binding var viewModel:SettingsViewModel
    var body: some View {
        VStack {
            HStack {
                Button("Website") {
                    viewModel.openWebsitePressed()
                }
                Spacer()
            }
            WebView(html: viewModel.privacyPolicyContent)
                .cornerRadius(6)
        }
        .onAppear {
            if viewModel.privacyPolicyContent.isEmpty {
                viewModel.fetchPrivacyPolicy { response in
                    viewModel.privacyPolicyContent = response
                }
            }
        }
    }
}

