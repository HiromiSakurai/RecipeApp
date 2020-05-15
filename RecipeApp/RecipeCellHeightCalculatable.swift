//
//  RecipeCellHeightCalculatable.swift
//  RecipeApp
//
//  Created by 櫻井寛海 on 2020/05/16.
//  Copyright © 2020 HiromiSakurai. All rights reserved.
//

import Foundation
import UIKit

protocol RecipeCellHeightCalculatable {
    var cellWidth: CGFloat { get }

    func getRecipeCellHeight() -> CGFloat
}

extension RecipeCellHeightCalculatable where Self: UICollectionViewFlowLayout {
    func getRecipeCellHeight() -> CGFloat {
        let string = NSAttributedString(
            // タイトルは2行固定のため、仮の2行文字列で計算
            string: "a\n", font: UIFont.systemFont(ofSize: RecipeCell.LayoutConst.titleFontSize),
            lineSpacing: RecipeCell.LayoutConst.titleLineSpacing,
            alignment: .left
        )
        return cellWidth + RecipeCell.LayoutConst.titleMarginTop + string.getBounds(width: .greatestFiniteMagnitude).height
    }
}

