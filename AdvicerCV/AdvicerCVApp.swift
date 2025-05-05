//
//  AdvicerCVApp.swift
//  AdvicerCV
//
//  Created by Mykhailo Dovhyi on 08.03.2025.
//

import SwiftUI
import Combine
@main
struct AdvicerCVApp: App {
    @State var appLoaded:Bool = false
    static var adPresenting = PassthroughSubject<Bool, Never>()
    static func triggerAdPresenting(with newValue: Bool = false) {
        adPresenting.send(newValue)
    }
    static var bannerCompletedPresenting:(()->())?
    @State var adPresenting:Bool = false
    @State var adPresentingValue:Set<AnyCancellable> = []

    var body: some Scene {
        WindowGroup {
            VStack(content: {
                if appLoaded {
                    HomeView()
                } else {
                    ProgressView()
                        .progressViewStyle(.circular)
                }
            })
            .background(content: {
                Color(.darkBlue)
                    .ignoresSafeArea(.all)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            })
                .onAppear {
                    AdvicerCVApp.adPresenting.sink { newValue in
                        self.adPresenting = newValue
                    }.store(in: &adPresentingValue)
                    DispatchQueue.init(label: "db", qos: .userInitiated).async {
                        NetworkModel().loadAppSettings {
                            DispatchQueue.main.async {
                                appLoaded = true
                            }
                        }
                    }
                    UITextView.appearance().backgroundColor = .clear
                    let appearance = UINavigationBarAppearance()
                     appearance.configureWithOpaqueBackground()
                     
//                     appearance.backgroundColor = .blue
                     appearance.titleTextAttributes = [.foregroundColor: UIColor.white,
                                                       .strokeColor:UIColor.white

                     ]
                    appearance.backButtonAppearance.normal.backgroundImage = nil
                     appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white,
                                                            .strokeColor:UIColor.white

                     ]
                     appearance.backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white,
                                                                                   .strokeColor:UIColor.white
                     ]
                    appearance.backgroundColor = .clear
                
                     UINavigationBar.appearance().standardAppearance = appearance
                     UINavigationBar.appearance().scrollEdgeAppearance = appearance
                }
                .overlay {
                    if adPresenting {
                        AdPresenterRepresentable(dismissed: {
                            AdvicerCVApp.bannerCompletedPresenting?()
                            AdvicerCVApp.adPresenting.send(false)

                        })
                    } else {
                        VStack{
                            
                        }.disabled(true)
                    }
                   
                }
//            GeneratorPDFView()
        }
    }
}
