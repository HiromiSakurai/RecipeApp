//
//  VideosSample.swift
//  RecipeAppKit
//
//  Created by 櫻井寛海 on 2020/05/12.
//  Copyright © 2020 HiromiSakurai. All rights reserved.
//

import Foundation

public struct VideosSample: Decodable {
    public let data: [Recipe]

    private enum CodingKeys : String, CodingKey {
        case data
    }
}
