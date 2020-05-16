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
}

final class FavoriteModelImpl: FavoriteModel {
    private let disk: Disk
    private let favoriteListRelay: BehaviorRelay<[Recipe]>
    private var memoryCache: Set<Recipe>

    init() {
        self.disk = Disk.shared

        let favoriteList: [Recipe] = Disk.shared.getObject(filename: .favoriteList) ?? []
        self.memoryCache = Set(favoriteList)
        self.favoriteListRelay = .init(value: favoriteList)
    }

    func getFavoriteList() -> Observable<[Recipe]> {
        favoriteListRelay.asObservable()
    }

    func addFavorite(recipe: Recipe) {
        if memoryCache.contains(recipe) {
            return
        }
        memoryCache.insert(recipe)

        var list = favoriteListRelay.mutableValue
        list.insert(recipe, at: 0)
        favoriteListRelay.mutableValue = list

        disk.writeObject(filename: .favoriteList, jsonEncodable: list)
    }

    func deleteFavorite(recipe: Recipe) {
        guard memoryCache.contains(recipe) else {
            return
        }
        memoryCache.remove(recipe)

        var list = favoriteListRelay.mutableValue
        list.remove(object: recipe)
        favoriteListRelay.mutableValue = list

        disk.writeObject(filename: .favoriteList, jsonEncodable: list)
    }
}

/// valueがread-onlyのため、writeを簡略化するためのutility
extension BehaviorRelay where Element: Any {
    var mutableValue: Element {
        set {
            self.accept(newValue)
        }
        get {
            return self.value
        }
    }
}

extension Array where Element: Equatable {
    mutating func remove(object: Element) {
        if let index = firstIndex(of: object) {
            remove(at: index)
        }
    }
}
