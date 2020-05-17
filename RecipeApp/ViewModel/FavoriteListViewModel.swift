//
//  FavoriteListViewModel.swift
//  RecipeApp
//
//  Created by Hiromi Sakurai on 2020/05/18.
//  Copyright © 2020 HiromiSakurai. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RecipeAppKit

protocol FavoriteListVewModel {
    func getFavoriteCellViewData() -> Driver<[SectionOfFavoriteCellViewData]>
}

final class FavoriteListVewModelImpl: FavoriteListVewModel {
    private let favoriteModel: FavoriteModel

    private let favoriteCellViewDataRelay = BehaviorRelay<[SectionOfFavoriteCellViewData]>(value: [])
    private let disposeBag = DisposeBag()

    init(favoriteModel: FavoriteModel) {
        self.favoriteModel = favoriteModel

        favoriteModel.getFavoriteList()
            .map { recipes -> [FavoriteCellViewData] in
                return recipes.map { recipe -> FavoriteCellViewData in
                    .init(
                        title: recipe.attributes.title,
                        thumbnailURL: recipe.attributes.thumbnailSquareURL
                    )
                }
            }
            .map { [.init(header: "", items: $0)] }
            .bind(to: favoriteCellViewDataRelay)
            .disposed(by: disposeBag)
    }

    func getFavoriteCellViewData() -> Driver<[SectionOfFavoriteCellViewData]> {
        favoriteCellViewDataRelay.asDriver()
    }
}
