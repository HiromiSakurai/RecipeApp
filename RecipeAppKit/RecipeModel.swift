//
//  RecipeModel.swift
//  RecipeAppKit
//
//  Created by Hiromi Sakurai on 2020/05/17.
//  Copyright © 2020 HiromiSakurai. All rights reserved.
//

import Foundation
import RxSwift

public protocol RecipeModel {
    func fetchRecipeList() -> Single<[Recipe]>
}

final class RecipeModelImpl: RecipeModel {
    private let client: Client

    init() {
        self.client = ClientImpl()
    }

    func fetchRecipeList() -> Single<[Recipe]> {
        client
            .request(API.getVideosSample())
            .map(\.data)
    }
}
