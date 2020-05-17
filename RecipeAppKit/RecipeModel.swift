//
//  RecipeModel.swift
//  RecipeAppKit
//
//  Created by Hiromi Sakurai on 2020/05/17.
//  Copyright © 2020 HiromiSakurai. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

public protocol RecipeModel {
    func getRecipeList() -> Observable<[Recipe]>
    func retrieveRecipe(using index: Int) -> Recipe?
}

public final class RecipeModelImpl: RecipeModel {
    private let client: Client
    private let recipeListRelay = BehaviorRelay<[Recipe]>(value: [])
    private let disposeBag = DisposeBag()

    public init() {
        self.client = ClientImpl()

        client
            .request(API.getVideosSample())
            .map(\.data)
            .asObservable()
            .bind(to: recipeListRelay)
            .disposed(by: disposeBag)
    }

    public func getRecipeList() -> Observable<[Recipe]> {
        recipeListRelay.asObservable()
    }

    public func retrieveRecipe(using index: Int) -> Recipe? {
        recipeListRelay.mutableValue[safe: index] ?? nil
    }
}

public extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
