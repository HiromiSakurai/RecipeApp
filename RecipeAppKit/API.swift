//
//  API.swift
//  RecipeAppKit
//
//  Created by 櫻井寛海 on 2020/05/12.
//  Copyright © 2020 HiromiSakurai. All rights reserved.
//

import Foundation

enum API {}

extension API {
    static func getVideosSample() -> Endpoint<VideosSample> {
        return Endpoint(path: "/videos_sample.json")
    }
}
