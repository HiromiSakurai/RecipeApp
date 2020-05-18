//
//  FavoriteListViewModelTest.swift
//  RecipeAppTests
//
//  Created by Hiromi Sakurai on 2020/05/18.
//  Copyright © 2020 HiromiSakurai. All rights reserved.
//

import XCTest
import RxSwift
@testable import RecipeApp
@testable import RecipeAppKit

class FavoriteListViewModelTest: XCTestCase {

    var sut: FavoriteListViewModel!

    var disposeBag: DisposeBag!
    var favoriteModel: FavoriteModelMock!

    override func setUpWithError() throws {
        disposeBag = DisposeBag()
        favoriteModel = FavoriteModelMock()
        favoriteModel.favoriteListStreamHandler = {
            return Observable.just([recipeDummy])
        }
        sut = FavoriteListViewModelImpl(favoriteModel: favoriteModel)
    }

    override func tearDownWithError() throws {
        sut = nil
        disposeBag = nil
        favoriteModel = nil
    }

    func testFavoriteListStream() throws {
        let exp = expectation(description: "初期化後にお気に入り一覧を流す")

        sut.favoriteCellViewDataStream()
            .drive(onNext: { favorites in
                XCTAssertFalse(favorites.first!.items.isEmpty)
                exp.fulfill()
            })
            .disposed(by: disposeBag)

        waitForExpectations(timeout: 1.0, handler: nil)

    }

    func testFavoriteCount() throws {
        let exp = expectation(description: "適切なお気に入り数が流れる")

        sut.favoriteCountStream()
            .drive(onNext: { count in
                XCTAssert(count == 1)
                exp.fulfill()
            })
            .disposed(by: disposeBag)

        waitForExpectations(timeout: 1.0, handler: nil)
    }
}
