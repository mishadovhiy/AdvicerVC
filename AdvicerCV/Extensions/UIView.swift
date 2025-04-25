//
//  UIView.swift
//  AdvicerCV
//
//  Created by Mykhailo Dovhyi on 25.04.2025.
//

import UIKit

extension UIView {
    var toImage:UIImage? {
        let renderer = UIGraphicsImageRenderer(size: bounds.size)
        return renderer.image { (context) in
            layer.render(in: context.cgContext)
        }
    }
}
