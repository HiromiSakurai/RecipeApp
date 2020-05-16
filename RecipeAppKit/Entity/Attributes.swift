//
//  Attributes.swift
//  RecipeAppKit
//
//  Created by 櫻井寛海 on 2020/05/12.
//  Copyright © 2020 HiromiSakurai. All rights reserved.
//

import Foundation

public struct Attributes: Codable {
    public let title: String
    public let thumbnailSquareURL: URL

    private enum CodingKeys : String, CodingKey {
        case title
        case thumbnailSquareURL = "thumbnail-square-url"
    }
}
