//
//  CVContent_mock.swift
//  AdvicerCV
//
//  Created by Mykhailo Dovhyi on 05.04.2025.
//

import Foundation

extension [GeneratorPDFViewModel.CVContent.ContentItem] {
    static var mockPortfolio: Self {
        [
.init(title: "Meal Calendar AI ", titleDesctiption: "apps.apple.com/ua/app/id6736599453", text: """
  OpenAI and Food Advisor APIs for getting calories and nutrition information about the ingredients, from
  Image or Text. Created backend for API integration with NodeJS, and managing MySQL database with
  PHP, hosting user's image with PHP. Client written with SwiftUI. Form-data content type for API requests
  """),
.init(title: "Video Editor App", titleDesctiption: "apps.apple.com/app/id6479946692 / github.com/mishadovhiy/videoEditor", text: """
  Features: Add on video: text, image, sound, filter or merge videos. Declarative UI
  - UIKit, AVFoundation, SOLID, OOP, FileManager, CIFilter, CoreGraphics, CoreAnimation, async/await,
  MVVM-C
  """)
]
    }
    static var mock: [GeneratorPDFViewModel.CVContent.ContentItem] {[
        .init(from:Calendar.current.date(byAdding: .year, value: -2, to: .init())!, to:Calendar.current.date(byAdding: .year, value: -1, to: .init())!, title: "Engenious – Remote (contract) - iOS Developer ", titleDesctiption: "apps.apple.com/ua/app/gochamp/id6448703105", text: """
            Bugfixing, refactoring, supporting daily sport planner app with video tutorials. Cross-platform team as Solo
            iOS Developer
            - Published to the AppStore
            - Rewrote app interface from Storyboards, xibs to code driven UI (UIKit). Integrated with: StoreKit
            Subscriptions, Keychain, AuthenticationServices, Google API, Facebook API, RESTful API integration,
            MVVM-C
            """),
        .init(from:Calendar.current.date(byAdding: .year, value: -3, to: .init())!, to:Calendar.current.date(byAdding: .year, value: -2, to: .init())!, title: "Black Rock South – Remote (full-time) - iOS developer ", titleDesctiption: "https://mishadovhiy.com/#rocks", text: """
            - As a solo iOS Developer, created iGaming social media app and messenger app by designs from Figma
            - Collaborated closely with a cross-platform team to ensure iOS application behaves and looks the same
            on all platforms
            - Integrated WebRTC for online chat app
            - Integrated communication between JavaScript and Swift
            - Shared design and animation ideas with the team, created declarative interface and reusable
            components with UIKit
            UIKit, SwiftUI, WebRTC, Remote Notifications, integrating API (Protobuf), Combine, creating reusable UI,
            deeplinks, SpriteKit, CoreAnimation, CoreData, Keychain, ReactNative, bridge JavaScript and Swift,
            MVVM-C, SOLID, DRY
            """),
        .init(from: Calendar.current.date(byAdding: .year, value: -4, to: .init())!, to: Calendar.current.date(byAdding: .year, value: -2, to: .init())!, title: "Exellio – Kyiv, Ukraine (full-time) - iOS Developer ", text: """
            - Supported POS application for iPad, integrated new features, bugfixing
            - Solo created and designed application for inventarisation for company Porsche, application connects
            with Bluetooth to the barcode scanner, credit card reader, fiscal printer, weights
            UIKit, Objective-C, SwiftUI, RESTful API, Soap, CoreBluetooth, CloudKit, Keychain, StoreKit, MVC
            """)
    ]}
}


extension GeneratorPDFViewModel.CVContent {
    static var mock:GeneratorPDFViewModel.CVContent {
        .init(workExperience: .mock,
              skills: [
            .init(title: "iOS SDK: - Core iOS Development:", text: """
        UIKit (4), SwiftUI (2), Concurrency (async/await, GCD), CoreData,
        Combine, RxSwift, Local Authentication (FaceID/TouchID), Remote Notifications, Cocoa Touch, StoreKit
        (in-app purchases), App Group, Cocoa (0.5), AppKit
        - Graphics, Animation, Video: AVFoundation (1.5), CoreGraphics, CoreAnimation, PDFKit,
        CoreText, SpriteKit (1), SceneKit (0.4), RealityKit (0.8), PensilKit
        - Machine Learning, Connection: CreateML, CoreML, Vision, MapKit, WebKit, CoreBluetooth
        - Apple Watch, Widgets and Specialized Technologies: WatchKit, WidgetKit, App Intents,
        WatchConnectivity, HealthKit, CoreMotion
        """),
            .init(title: "Data Storage:", text: "FileManager, CoreData, CloudKit, UserDefaults, FirebaseFirestore, Keychain"),
            .init(title: "Interface", text: "SwiftUI, Storyboards, XIB, Code driven UI with UIKit, AutoLayout, IBInspectable, Texture"),
            .init(title: "Networking and Integrations:", text: """
                RESTful API, WebRTC, Soap, MySQL, JSON, XML, Protocol Buffers,
                Codable, deeplinks
                """),
            .init(title: "Back-End development:", text: "Node.js, PHP, MySQL"),
            .init(title: "Architectural patterns:", text: "MVVM+C, VIPER, MVP, Clean Swift, OOP principles, DRY, SOLID, MVC"),
            .init(title: "Distribution, Testing", text: """
                App Store, Enterprise (.ipa), TestFlight, XCTest, Unit Tests, Provisioning profile,
                Code signing, Jenkins
                """),
            .init(title: "Version Control:", text: "git, gitlab, bitbucket"),
            .init(title: "3rd party libraries integration:", text: """
                CocoaPods, Swift Packages: integration & creation, gcloud Services API,
                OpenAI, Firebase, GoogleMobileAds, FacebookSDK, Lottie, Alamofire, SnapKit, AppsFlyer, mixpanel
                """),
            .init(title: "Tools:", text: """
                Xcode Instruments, Debug view hierarchy, Git, Terminal, Sketch/Figma, Sourcetree, FileZilla,
                SublimeText, Mamp, Trello, Jira, Android Studio, SoapU, Postman, Reality Converter
                """)
        ],
              summary: [.init(text:"""
Swift Developer with 4.5 years of commercial experience in iOS development. Created several projects
from scratch as a solo iOS Developer, in a cross-platform team, and in a team of iOS Developers. Have
created several pet projects for the AppStore (over 8 apps), including Video Editor, AI Meal Calendar
apps, Puzzle Game, and more with WidgetKit, WatchKit, RealityKit, CoreML, CoreGraphics, PDFKit
Proven track record in integrating APIs, deploying apps to the App Store, bugdixing. Ensuring clean and
reusable code that easily scales and readable for the team. Deep understanding in Memory management
and multithreading. Additionally, have 2 years of commercial experience in Front-End web development,
building REST API with NodeJS, PHP and MySQL database.
""", boldTexts: "Video Editor, AI Meal Calendar")],
              jobTitle: [.init(title: "iOS Developer")],
              titleDescription: [.init(title: """
    Kyiv, Ukraine | github.com/mishadovhiy | apps.apple.com/developer/id1511515116
    mishadovhiy.com | developer@mishadovhiy.com
    """)],
              contacts: [
    .init(title: "Email", titleDesctiption: "hi@mishadovhiy.com"),
    .init(title: "", titleDesctiption: "mishadovhiy.com")
],
              education: [
    .init(from: .init(), to: .init(), title: "Kyiv University of Tourism, Economics and Law, Kyiv, Ukraine ", text: "Bachelor's degree - Management")
],
              portfolio: .mockPortfolio)
    }
}
