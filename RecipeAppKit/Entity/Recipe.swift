//
//  Recipe.swift
//  RecipeAppKit
//
//  Created by 櫻井寛海 on 2020/05/12.
//  Copyright © 2020 HiromiSakurai. All rights reserved.
//

import Foundation

public struct Recipe: Codable, Equatable, Hashable {
    public let ID: String
    public let type: String
    public let attributes: Attributes

    private enum CodingKeys : String, CodingKey {
        case ID = "id"
        case type
        case attributes
    }
}
