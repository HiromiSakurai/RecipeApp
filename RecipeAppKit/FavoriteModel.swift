//
//  FavoriteModel.swift
//  RecipeAppKit
//
//  Created by Hiromi Sakurai on 2020/05/17.
//  Copyright © 2020 HiromiSakurai. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

public protocol FavoriteModel {
    func getFavoriteList() -> Observable<[Recipe]>
    func addFavorite(recipe: Recipe)
    func deleteFavorite(recipe: Recipe)
    func isFavorite(recipe: Recipe) -> Bool
}

final class FavoriteModelImpl: FavoriteModel {
    private let disk: Disk
    private let favoriteListRelay: BehaviorRelay<[Recipe]>
    private var memoryCache: Set<Recipe>

    init() {
        self.disk = Disk.shared

        let favoriteList: [Recipe] = disk.getObject(filename: .favoriteList) ?? []
        self.memoryCache = Set(favoriteList)
        self.favoriteListRelay = .init(value: favoriteList)
    }

    func getFavoriteList() -> Observable<[Recipe]> {
        favoriteListRelay.asObservable()
    }

    func addFavorite(recipe: Recipe) {
        if isFavorite(recipe: recipe) {
            return
        }
        memoryCache.insert(recipe)

        var list = favoriteListRelay.mutableValue
        list.insert(recipe, at: 0)
        favoriteListRelay.mutableValue = list

        disk.writeObject(filename: .favoriteList, jsonEncodable: list)
    }

    func deleteFavorite(recipe: Recipe) {
        guard isFavorite(recipe: recipe) else {
            return
        }
        memoryCache.remove(recipe)

        var list = favoriteListRelay.mutableValue
        list.remove(object: recipe)
        favoriteListRelay.mutableValue = list

        disk.writeObject(filename: .favoriteList, jsonEncodable: list)
    }

    func isFavorite(recipe: Recipe) -> Bool {
        memoryCache.contains(recipe)
    }
}
