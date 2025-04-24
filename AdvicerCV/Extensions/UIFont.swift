//
//  UIFont.swift
//  AdvicerCV
//
//  Created by Mykhailo Dovhyi on 24.04.2025.
//

import UIKit

extension UIFont.Weight {
    static var allCases: [UIFont.Weight] {
        [.light, .regular, .semibold, .bold]
    }
    
    var string:String {
        switch self {
        case .light:"light"
        case .regular:"regular"
        case .medium:"medium"
        case .semibold:"semibold"
        case .bold:"bold"
        case .black:"black"

        default:
            ""
        }
    }
}
