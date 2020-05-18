//
//  RecipeListViewModelTests.swift
//  RecipeAppTests
//
//  Created by 櫻井寛海 on 2020/05/12.
//  Copyright © 2020 HiromiSakurai. All rights reserved.
//

import XCTest
import RxSwift
@testable import RecipeApp
@testable import RecipeAppKit

class RecipeListViewModelTests: XCTestCase {

    var sut: RecipeListViewModel!

    var disposeBag: DisposeBag!
    var recipeModel: RecipeModelMock!
    var favoriteModel: FavoriteModelMock!

    override func setUpWithError() throws {
        disposeBag = DisposeBag()

        recipeModel = RecipeModelMock()
        recipeModel.recipeListStreamHandler = {
            return Observable.just([recipeDummy])
        }
        recipeModel.retrieveRecipeHandler = { _ in
            return recipeDummy
        }
        favoriteModel = FavoriteModelMock()
        favoriteModel.isFavoriteHandler = { _ in
            return false
        }

        sut = RecipeListViewModelImpl(recipeModel: recipeModel, favoriteModel: favoriteModel)
    }

    override func tearDownWithError() throws {
        sut = nil
        disposeBag = nil
        recipeModel = nil
        favoriteModel = nil
    }

    func testRecipeListViewModel() throws {
        let getRecipeListExp = XCTestExpectation(description: "初期化後にレシピ一覧を流す")
        let toggleFavoriteExp = XCTestExpectation.init(description: "指定したアイテムのお気に入り状態を逆転する")

        sut.recipeCellViewDataStream()
            .drive(onNext: { [weak self] recipes in
                if !recipes.first!.items.isEmpty {
                    getRecipeListExp.fulfill()

                    self?.sut.toggleFavorite(at: .init(item: 0, section: 0 ))
                }

                if recipes.first!.items.first!.isFavorite {
                    toggleFavoriteExp.fulfill()
                }
            })
            .disposed(by: disposeBag)

        wait(for: [getRecipeListExp, toggleFavoriteExp], timeout: 1.0)
    }
}

var recipeDummy: Recipe {
    let attr = Attributes(title: "title", thumbnailSquareURL: URL(string: "dummy.com")!)
    return Recipe(ID: "ID", type: "video", attributes: attr)
}
