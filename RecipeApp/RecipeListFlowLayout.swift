//
//  RecipeListFlowLayout.swift
//  RecipeApp
//
//  Created by 櫻井寛海 on 2020/05/16.
//  Copyright © 2020 HiromiSakurai. All rights reserved.
//

import Foundation
import UIKit

final class RecipeListFlowLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        self.minimumInteritemSpacing = 12
        self.minimumLineSpacing = 24
        self.scrollDirection = .vertical
        let contentInset = LayoutConst.contentInset
        self.sectionInset = .init(top: contentInset, left: contentInset, bottom: 0, right: contentInset)
        self.sectionInsetReference = .fromSafeArea
    }

    override func prepare() {
        super.prepare()

        guard collectionView != nil else { return }

        self.itemSize = .init(width: cellWidth, height: getRecipeCellHeight())
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RecipeListFlowLayout {
    enum LayoutConst {
        static let contentInset: CGFloat = 12
    }
}

// MARK: - RecipeCellHeightCalculatable

extension RecipeListFlowLayout: RecipeCellHeightCalculatable {
    var cellWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 180
        }

        return ((collectionView.bounds.width - LayoutConst.contentInset * 3) / 2).rounded(.down)
    }
}

