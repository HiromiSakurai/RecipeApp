//
//  SectionOfRecipeCellViewData.swift
//  RecipeApp
//
//  Created by Hiromi Sakurai on 2020/05/17.
//  Copyright © 2020 HiromiSakurai. All rights reserved.
//

import Foundation
import RxDataSources

struct SectionOfRecipeCellViewData {
    var header: String
    var items: [Item]
}
extension SectionOfRecipeCellViewData: SectionModelType {
    typealias Item = RecipeCellViewData

    init(original: SectionOfRecipeCellViewData, items: [Item]) {
        self = original
        self.items = items
    }
}
