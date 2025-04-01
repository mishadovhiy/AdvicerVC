//
//  SavedAdviceView.swift
//  AdvicerCV
//
//  Created by Mykhailo Dovhyi on 01.04.2025.
//

import SwiftUI

struct SavedAdviceView: View {
    @ObservedObject var viewModel: AdviceViewModel
    @EnvironmentObject var db: AppData

    var body: some View {
        Text("")
    }
}

#Preview {
    NavigationView {
        SavedAdviceView(viewModel: AdviceViewModel())
    }
} 
