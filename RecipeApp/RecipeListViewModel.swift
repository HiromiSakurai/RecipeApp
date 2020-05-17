//
//  RecipeListViewModel.swift
//  RecipeApp
//
//  Created by Hiromi Sakurai on 2020/05/17.
//  Copyright © 2020 HiromiSakurai. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RecipeAppKit

struct RecipeCellViewData {
    let title: String
    let thumbnailURL: URL
    var isFavorite: Bool
}

protocol RecipeListViewModel {
    func getRecipeCellViewData() -> Driver<[RecipeCellViewData]>
    func toggleFavorite(at indexPath: IndexPath)
}

final class RecipeListViewModelImpl: RecipeListViewModel {
    private let recipeModel: RecipeModel
    private let favoriteModel: FavoriteModel

    private let recipeCellViewDataRelay = BehaviorRelay<[RecipeCellViewData]>(value: [])
    private let disposeBag = DisposeBag()

    init(recipeModel: RecipeModel, favoriteModel: FavoriteModel) {
        self.recipeModel = recipeModel
        self.favoriteModel = favoriteModel

        recipeModel.fetchRecipeList()
            .map { recipes -> [RecipeCellViewData] in
                return recipes.map { [weak self] recipe -> RecipeCellViewData? in
                    guard let self = self else {
                        return nil
                    }

                    return .init(
                        title: recipe.attributes.title,
                        thumbnailURL: recipe.attributes.thumbnailSquareURL,
                        isFavorite: self.checkIsFavorite(recipe: recipe)
                    )
                }
                .compactMap { $0 }
            }
            .asObservable()
            .bind(to: recipeCellViewDataRelay)
            .disposed(by: disposeBag)
    }

    func getRecipeCellViewData() -> Driver<[RecipeCellViewData]> {
        recipeCellViewDataRelay.asDriver()
    }

    func toggleFavorite(at indexPath: IndexPath) {
        let newData = recipeCellViewDataRelay.mutableValue.enumerated()
            .map { (index, element) -> RecipeCellViewData in
                if index == indexPath.item {
                    var target = element
                    target.isFavorite.toggle()
                    return target
                } else {
                    return element
                }
            }

        recipeCellViewDataRelay.mutableValue = newData
    }

    private func checkIsFavorite(recipe: Recipe) -> Bool {
        favoriteModel.isFavorite(recipe: recipe)
    }
}
