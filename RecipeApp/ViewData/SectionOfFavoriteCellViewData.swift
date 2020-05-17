//
//  SectionOfFavoriteCellViewData.swift
//  RecipeApp
//
//  Created by Hiromi Sakurai on 2020/05/18.
//  Copyright © 2020 HiromiSakurai. All rights reserved.
//

import Foundation
import RxDataSources

struct SectionOfFavoriteCellViewData {
    var header: String
    var items: [Item]
}

extension SectionOfFavoriteCellViewData: SectionModelType {
    typealias Item = FavoriteCellViewData

    init(original: SectionOfFavoriteCellViewData, items: [Item]) {
        self = original
        self.items = items
    }
}
