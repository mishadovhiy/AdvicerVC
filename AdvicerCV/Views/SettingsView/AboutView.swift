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
            VStack {
                ForEach(viewModel.aboutData, id:\.title) { data in
                    VStack {
                        Text(data.title)
                        Text(data.description)
                            .padding(.leading, data.title.isEmpty ? 15 : 0)
                    }
                    if !data.title.isEmpty {
                        Divider()
                    }
                    
                }
            }
        }
    }
    
    struct ContentItem {
        let title:String
        var description:String = ""
    }
}

