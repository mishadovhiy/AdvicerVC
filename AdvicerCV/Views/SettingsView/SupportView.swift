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
        VStack(content: {
            Spacer().frame(height: 5)
            ScrollView(.vertical) {
                VStack {
                    VStack(spacing:10) {
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
                                .foregroundColor(.white)
                                .font(.system(size: 12))
                        }
                        .frame(maxHeight:viewModel.supportRequestCompleted != nil ? .infinity : 0)
                        .clipped()
                        .animation(.bouncy, value: viewModel.supportRequestCompleted != nil)
                    }
                    .padding(10)
                    .background {
                        Color(.Special.lightPurpure)
                            .cornerRadius(12)
                    }
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
                        .tint(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color(.Special.lightPurpure))
                        .cornerRadius(4)
                    }
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 10)
            }
        })
        .navigationTitle("Support")
        .background(content: {
            VStack {
                Color(.Special.lightPurpure)
                    .frame(height: 44)
                    .offset(y:-44)
                Spacer()
            }
        })
    }
    
    func itemView(_ title:String, text:Binding<String>) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .foregroundColor(.darkText)
            TextField("Enter \(title)", text: text)
                .foregroundColor(.white)
                .padding(.horizontal, 5)
                .padding(.vertical, 7)
                .background(Color(.darkText))
                .cornerRadius(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

