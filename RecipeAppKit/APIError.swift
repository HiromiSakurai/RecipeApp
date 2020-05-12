//
//  APIError.swift
//  RecipeAppKit
//
//  Created by 櫻井寛海 on 2020/05/12.
//  Copyright © 2020 HiromiSakurai. All rights reserved.
//

import Foundation

public enum APIError: Error {
    case decodingFailure
    case noResponse
}
