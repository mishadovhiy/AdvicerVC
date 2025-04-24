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
            VStack(alignment:.leading, spacing: 0) {
                VStack {
                    Text("About app")
                        .font(.system(size: 24, weight:.semibold))
                        .foregroundColor(Color(.white))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 20)
                    AboutView(viewModel: $viewModel)
                }
                .padding(.horizontal, 10)
                .background(Color(.Special.lightPurpure))
                    .cornerRadius(35)
                settings

            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background {
                ClearBackgroundView()
            }
            .background(HomeViewModel.PresentingTab.settings.color)

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
        .background(HomeViewModel.PresentingTab.settings.color)
    }
    
    var settings: some View {
        VStack(alignment:.leading) {
            HStack {
                Button("Rate") {
                    StorekitModel().requestReview()
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(Color(.Special.purpure))
                .cornerRadius(4)
                Button("Share") {
                    viewModel.navigationPresenting.share = true
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(Color(.Special.purpure))
                .cornerRadius(4)
            }
            HStack {
                NavigationLink("Support", destination: SupportView(viewModel: $viewModel))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color(.Special.purpure))
                    .cornerRadius(4)
                NavigationLink("Privacy Policy", destination: PrivacyPolicyView(viewModel: $viewModel))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color(.Special.purpure))
                    .cornerRadius(4)
                Button("Clear data") {
                    viewModel.navigationPresenting.clearData = true
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(Color(.Special.red).opacity(0.15))
                .cornerRadius(4)
                .tint(Color(.Special.red))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .tint(.white)
        .padding(.leading, 15)
        .padding(.bottom, 15)
        .padding(.top, 10)
    }

}

#Preview {
    SettingsView()
}
