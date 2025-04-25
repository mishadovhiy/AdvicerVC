//
//  Keys.swift
//  AdvicerCV
//
//  Created by Mykhailo Dovhyi on 31.03.2025.
//

import Foundation

enum Keys:String {
    case openAIToken = "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"
    case openAIChatURL = "https://api.openai.com/v1/chat/completions"
    case appStoreID = "6744907347"
    case websiteURL = "https://mishadovhiy.com/#advicercv"
    case privacyPolicy = "https://mishadovhiy.com/apps/previews/advicercv.html"

    static var shareAppURL:String = "https://apps.apple.com/app/id\(Keys.appStoreID.rawValue)"

}
