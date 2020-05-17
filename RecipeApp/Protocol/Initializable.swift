//
//  Initializable.swift
//  RecipeApp
//
//  Created by Hiromi Sakurai on 2020/05/17.
//  Copyright © 2020 HiromiSakurai. All rights reserved.
//

import Foundation

protocol Initializable {
    associatedtype ViewModelType

    static func initialize(viewModel: ViewModelType) -> Self
}
