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
    func recipeCellViewDataStream() -> Driver<[SectionOfRecipeCellViewData]>
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

        recipeModel.recipeListStream()
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

    func recipeCellViewDataStream() -> Driver<[SectionOfRecipeCellViewData]> {
        recipeCellViewDataRelay.asDriver()
    }

    func toggleFavorite(at indexPath: IndexPath) {
        guard var recipeCellViewData = recipeCellViewDataRelay.mutableValue.first?.items,
            var target = recipeCellViewData[safe: indexPath.item],
            let recipe = recipeModel.retrieveRecipe(using: indexPath.item) else {
            return
        }

        if target.isFavorite {
            favoriteModel.deleteFavorite(recipe: recipe)
        } else {
            favoriteModel.addFavorite(recipe: recipe)
        }

        target.isFavorite.toggle()
        recipeCellViewData[indexPath.item] = target

        recipeCellViewDataRelay.mutableValue = [.init(header: "", items: recipeCellViewData)]
    }

    private func checkIsFavorite(recipe: Recipe) -> Bool {
        favoriteModel.isFavorite(recipe: recipe)
    }
}
