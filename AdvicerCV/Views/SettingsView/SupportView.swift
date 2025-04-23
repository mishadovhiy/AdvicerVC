//
//  SupportView.swift
//  AdvicerCV
//
//  Created by Mykhailo Dovhyi on 22.04.2025.
//

import SwiftUI

struct SupportView: View {
    @Binding var viewModel:SettingsViewModel

    var body: some View {
        ScrollView(.vertical) {
            VStack {
                VStack {
                    itemView("Header", text: $viewModel.supportRequest.header)
                    Divider()
                    itemView("Title", text: $viewModel.supportRequest.title)
                    Divider()
                    itemView("Text", text: $viewModel.supportRequest.text)
Divider()
                    VStack {
                        Text(viewModel.supportRequestCompleted?.title ?? "")
                            .font(.system(size: 16, weight:.semibold))

                        Text(viewModel.supportRequestCompleted?.text ?? "")
                            .font(.system(size: 12))
                    }
                    .frame(maxHeight:viewModel.supportRequestCompleted != nil ? .infinity : 0)
                    .clipped()
                    .animation(.bouncy, value: viewModel.supportRequestCompleted != nil)
                }
                .padding(5)

                HStack {
                    Spacer()
                    Button("Send") {
                        viewModel.sendSupportRequest { ok in
                            if ok {
                                
                            }
                            withAnimation {
                                viewModel.supportRequestCompleted = ok ? .init(title: "Your request has been sent!") : .init(title: "Error sending request", text:"Try again later")
                                if ok {
                                    viewModel.supportRequest = .init(text: "", header: "", title: "")
                                }
                                
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                                withAnimation {
                                    viewModel.supportRequestCompleted = nil
                                }
                            })
                        }
                    }
                }
            }
            
        }
    }
    
    func itemView(_ title:String, text:Binding<String>) -> some View {
        VStack {
            Text(title)
            TextField("", text: text)
        }
    }
}

