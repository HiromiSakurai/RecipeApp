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

/// @mockable
protocol FavoriteListViewModel {
    func favoriteCellViewDataStream() -> Driver<[SectionOfFavoriteCellViewData]>
    func favoriteCountStream() -> Driver<Int>
}

final class FavoriteListViewModelImpl: FavoriteListViewModel {
    private let favoriteModel: FavoriteModel

    private let favoriteCellViewDataRelay = BehaviorRelay<[SectionOfFavoriteCellViewData]>(value: [])
    private let favoriteCountRelay = BehaviorRelay<Int?>(value: nil)
    private let disposeBag = DisposeBag()

    init(favoriteModel: FavoriteModel) {
        self.favoriteModel = favoriteModel

        let favoriteList = self.favoriteModel.favoriteListStream()

        favoriteList
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

        favoriteList
            .map { $0.count }
            .bind(to: favoriteCountRelay)
            .disposed(by: disposeBag)
    }

    func favoriteCellViewDataStream() -> Driver<[SectionOfFavoriteCellViewData]> {
        favoriteCellViewDataRelay.asDriver()
    }

    func favoriteCountStream() -> Driver<Int> {
        favoriteCountRelay
            .asDriver()
            .compactMap { $0 }
    }
}
