//
//  AboutView.swift
//  AdvicerCV
//
//  Created by Mykhailo Dovhyi on 22.04.2025.
//

import SwiftUI

struct AboutView: View {
    @Binding var viewModel:SettingsViewModel
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment:.leading, spacing:10) {
                Text("About app")
                    .font(.system(size: 24, weight:.semibold))
                    .foregroundColor(Color(.white))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 20)
                ForEach(viewModel.aboutData, id:\.id) { data in
                    VStack(alignment:.leading, spacing: 5) {
                        if !data.title.isEmpty && data.id != viewModel.aboutData.first?.id {
                            Divider()
                                .padding(.vertical, 10)
                        }
                        if !data.title.isEmpty {
                            Text(data.title)
                                .font(.system(size: 16, weight: .medium))
                                .padding(.leading, data.hasBullets ? 15 : 0)
                                .foregroundColor(.white)
                        }
                        

                        if !data.description.isEmpty {
                            Text(data.description)
                                .font(.system(size: 13))

                                .padding(.leading, data.hasBullets ? 15 : 0)
                                .foregroundColor(.white)
                        }
                        

                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 20)
        }
    }
    
    struct ContentItem {
        let title:String
        var description:String = ""
        var id:UUID = .init()
        var hasBullets = false
    }
}

