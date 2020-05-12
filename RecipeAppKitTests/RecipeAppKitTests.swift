//
//  RecipeAppKitTests.swift
//  RecipeAppKitTests
//
//  Created by 櫻井寛海 on 2020/05/12.
//  Copyright © 2020 HiromiSakurai. All rights reserved.
//

import XCTest
import RxSwift
import Alamofire
@testable import RecipeAppKit

class RecipeAppKitTests: XCTestCase {

    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}

    func testGetVideosSample() throws {
        let exp = expectation(description: "get video sample")
        let client = ClientImpl()

        _ = client.request(API.getVideosSample())
            .subscribe(onSuccess: { res in
                XCTAssertNotNil(res)
                exp.fulfill()
            }, onError: { err in
                print(err)
            })

        waitForExpectations(timeout: 3)
    }
}
