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

public final class RecipeModelImpl: RecipeModel {
    private let client: Client

    public init() {
        self.client = ClientImpl()
    }

    public func fetchRecipeList() -> Single<[Recipe]> {
        client
            .request(API.getVideosSample())
            .map(\.data)
    }
}
