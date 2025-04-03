//
//  AttributedTextView.swift
//  AdvicerCV
//
//  Created by Mykhailo Dovhyi on 02.04.2025.
//

import SwiftUI
import UIKit

struct AttributedTextView: UIViewRepresentable {
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    let attributedString: NSAttributedString
    var didPressLink:(_ link:String, _ at:NSRange)->()
    func makeUIView(context: Context) -> UITextView {
        context.coordinator.didPressLink = self.didPressLink
        
        let label = UITextView()
        label.attributedText = attributedString
        label.delegate = context.coordinator
        label.isEditable = false
        label.backgroundColor = .clear
        label.dataDetectorTypes = [] // disable automatic links
        label.textContainerInset = .zero
        label.textContainer.lineFragmentPadding = 0
        return label
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.attributedText = attributedString
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var didPressLink:((_ link:String, _ at:NSRange)->())?

        func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
                if URL.scheme == "action" {
                    print(URL.host, " gvhjbknm ", characterRange)
                    didPressLink?(URL.host ?? "?", characterRange)
                    if URL.host == "custom1" {
                    }
                    return false
                }
                return true
            }
    }
}
