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
                .tint(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(Color(.Special.lightPurpure))
                .cornerRadius(4)
                Spacer()
            }
            WebView(html: viewModel.privacyPolicyContent)
                .cornerRadius(6)
        }

        .padding(10)
        .background(content: {
            VStack {
                Color(.Special.lightPurpure)
                    .frame(height: 44)
                    .offset(y:-44)
                Spacer()
            }
        })
        .background {
            ClearBackgroundView()
        }
        .background(HomeViewModel.PresentingTab.settings.color)
        .onAppear {
            if viewModel.privacyPolicyContent.isEmpty {
                viewModel.fetchPrivacyPolicy { response in
                    viewModel.privacyPolicyContent = response
                }
            }
        }
    }
}

