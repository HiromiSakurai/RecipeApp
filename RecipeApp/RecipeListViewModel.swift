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

protocol RecipeListViewModel {
    func getRecipeCellViewData() -> Driver<[SectionOfRecipeCellViewData]>
    func toggleFavorite(at indexPath: IndexPath)
}

final class RecipeListViewModelImpl: RecipeListViewModel {
    private let recipeModel: RecipeModel
    private let favoriteModel: FavoriteModel

    private let recipeCellViewDataRelay = BehaviorRelay<[SectionOfRecipeCellViewData]>(value: [])
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
            .map { [.init(header: "", items: $0)] }
            .asObservable()
            .bind(to: recipeCellViewDataRelay)
            .disposed(by: disposeBag)
    }

    func getRecipeCellViewData() -> Driver<[SectionOfRecipeCellViewData]> {
        recipeCellViewDataRelay.asDriver()
    }

    func toggleFavorite(at indexPath: IndexPath) {
        guard let recipes = recipeCellViewDataRelay.mutableValue.first?.items else {
            return
        }

        let newRecipes = recipes.enumerated()
            .map { (index, element) -> RecipeCellViewData in
                if index == indexPath.item {
                    var target = element
                    target.isFavorite.toggle()
                    return target
                } else {
                    return element
                }
            }

        recipeCellViewDataRelay.mutableValue = [.init(header: "", items: newRecipes)]
    }

    private func checkIsFavorite(recipe: Recipe) -> Bool {
        favoriteModel.isFavorite(recipe: recipe)
    }
}
