//
//  SettingsView.swift
//  AdvicerCV
//
//  Created by Mykhailo Dovhyi on 22.04.2025.
//

import SwiftUI

struct SettingsView: View {
    @State var viewModel:SettingsViewModel = .init()
    @EnvironmentObject var db:AppData
    var body: some View {
        NavigationView {
            VStack(alignment:.leading, spacing: 20) {
                NavigationLink("About", destination: AboutView(viewModel: $viewModel))
                Button("Rate") {
                    StorekitModel().requestReview()
                }
                Button("Share") {
                    viewModel.navigationPresenting.share = true
                }
                NavigationLink("Support", destination: SupportView(viewModel: $viewModel))
                NavigationLink("Privacy Policy", destination: PrivacyPolicyView(viewModel: $viewModel))
                Button("Clear data") {
                    viewModel.navigationPresenting.clearData = true
                }
                .tint(.red)
                
                Spacer()
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 5)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .sheet(isPresented: $viewModel.navigationPresenting.share) {
            ShareSheet(items: [Keys.shareAppURL])
        }
        .confirmationDialog("Are you sure you want to delete all your data?", isPresented: $viewModel.navigationPresenting.clearData) {
            Button("Yes") {
                viewModel.navigationPresenting.clearData = false
                db.db = .init()
            }
            Button("Cancel") {
                viewModel.navigationPresenting.clearData = false
            }
        }
    }
}

#Preview {
    SettingsView()
}
