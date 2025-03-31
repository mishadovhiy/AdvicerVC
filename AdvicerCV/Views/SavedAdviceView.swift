import SwiftUI

struct SavedAdviceView: View {
    @ObservedObject var viewModel: AdviceViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.adviceSections) { section in
                Section(header: Text(section.title).font(.headline)) {
                    ForEach(section.items, id: \.self) { item in
                        Text(item)
                            .padding(.vertical, 4)
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("CV Advice")
    }
}

#Preview {
    NavigationView {
        SavedAdviceView(viewModel: AdviceViewModel())
    }
} 