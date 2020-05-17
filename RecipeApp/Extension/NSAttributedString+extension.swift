//
//  NSAttributedString+extension.swift
//  RecipeApp
//
//  Created by 櫻井寛海 on 2020/05/16.
//  Copyright © 2020 HiromiSakurai. All rights reserved.
//

import Foundation
import UIKit

extension NSAttributedString {
    convenience init(string: String, font: UIFont, lineSpacing: CGFloat, alignment: NSTextAlignment) {
        var attributes: [NSAttributedString.Key: Any] = [:]

        attributes.updateValue(font, forKey: .font)

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = alignment
        attributes.updateValue(paragraphStyle, forKey: .paragraphStyle)

        self.init(string: string, attributes: attributes)
    }

    func getBounds(width: CGFloat) -> CGSize {
        let bounds = CGSize(width: width, height: .greatestFiniteMagnitude)
        let options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
        let rect = boundingRect(with: bounds, options: options, context: nil)
        return CGSize(width: rect.size.width, height: ceil(rect.size.height))
    }
}

