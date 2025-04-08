//
//  View.swift
//  AdvicerCV
//
//  Created by Mykhailo Dovhyi on 08.04.2025.
//

import SwiftUI

extension View {
    func endEditingKeyboard() {
#if os(watchOS)
        #else
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
#endif
    }
}
