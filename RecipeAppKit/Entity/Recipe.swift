//
//  Recipe.swift
//  RecipeAppKit
//
//  Created by 櫻井寛海 on 2020/05/12.
//  Copyright © 2020 HiromiSakurai. All rights reserved.
//

import Foundation

public struct Recipe: Codable {
    public let ID: String
    public let type: String
    public let attributes: Attributes

    private enum CodingKeys : String, CodingKey {
        case ID = "id"
        case type
        case attributes
    }
}

// MARK: - Hashable

extension Recipe: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ID)
    }
}

// MARK: - Equatable

extension Recipe: Equatable {
    public static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        lhs.ID == rhs.ID
    }
}
