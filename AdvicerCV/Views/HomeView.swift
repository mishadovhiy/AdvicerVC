import SwiftUI
import UniformTypeIdentifiers

struct HomeView: View {
    @StateObject private var viewModel = AdviceViewModel()
    @State private var isDocumentPickerPresented = false
    @State private var navigateToAdvice = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "doc.text.magnifyingglass")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)
                
                Text("CV Advisor")
                    .font(.largeTitle)
                    .bold()
                
                VStack(spacing: 16) {
                    Button(action: {
                        isDocumentPickerPresented = true
                    }) {
                        HStack {
                            Image(systemName: "arrow.up.doc")
                            Text("Upload CV")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    
                    NavigationLink(destination: SavedAdviceView(viewModel: viewModel)) {
                        HStack {
                            Image(systemName: "list.bullet.clipboard")
                            Text("My Advices")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
            .navigationBarHidden(true)
            .sheet(isPresented: $isDocumentPickerPresented) {
                DocumentPicker(
                    types: viewModel.documentTypes,
                    onDocumentPicked: { url in
                        viewModel.processDocument(url)
                        navigateToAdvice = true
                    }
                )
            }
            .background(
                NavigationLink(
                    destination: SavedAdviceView(viewModel: viewModel),
                    isActive: $navigateToAdvice,
                    label: { EmptyView() }
                )
            )
        }
    }
}

struct DocumentPicker: UIViewControllerRepresentable {
    let types: [UTType]
    let onDocumentPicked: (URL) -> Void
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: types)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: DocumentPicker
        
        init(_ parent: DocumentPicker) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else { return }
            parent.onDocumentPicked(url)
        }
    }
}

#Preview {
    HomeView()
} 