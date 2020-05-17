//
//  RecipeListFlowLayout.swift
//  RecipeApp
//
//  Created by 櫻井寛海 on 2020/05/16.
//  Copyright © 2020 HiromiSakurai. All rights reserved.
//

import Foundation
import UIKit

typealias FavoriteListFlowLayout = RecipeListFlowLayout

final class RecipeListFlowLayout: UICollectionViewFlowLayout {

    private var cellWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 180
        }

        return ((collectionView.bounds.width - LayoutConst.contentInset * 3) / 2).rounded(.down)
    }

    init(sectionInset: UIEdgeInsets) {
        super.init()
        self.sectionInset = sectionInset
        self.minimumInteritemSpacing = 12
        self.minimumLineSpacing = 24
        self.scrollDirection = .vertical
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
    var thumbnailHeight: CGFloat {
        cellWidth
    }
}

