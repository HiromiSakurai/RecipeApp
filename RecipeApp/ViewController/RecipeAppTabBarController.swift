//
//  RecipeAppTabBarController.swift
//  RecipeApp
//
//  Created by 櫻井寛海 on 2020/05/16.
//  Copyright © 2020 HiromiSakurai. All rights reserved.
//

import Foundation
import UIKit

final class RecipeAppTabBarController: UITabBarController {
    private let recipeListTabItem: UITabBarItem = {
        let item = UITabBarItem()
        item.title = "レシピ"
        item.image = UIImage(named: "home")
        return item
    }()

    private let favoreteListTabItem: UITabBarItem = {
        let item = UITabBarItem()
        item.title = "お気に入り"
        item.image = UIImage(named: "favorite")
        return item
    }()

    init(recipeListVC: RecipeListViewController, favoriteListVC: FavoriteListViewController) {
        super.init(nibName: nil, bundle: nil)

        recipeListVC.tabBarItem = recipeListTabItem
        favoriteListVC.tabBarItem = favoreteListTabItem

        let recipeListNav = UINavigationController(rootViewController: recipeListVC)
        let favoriteListNav = UINavigationController(rootViewController: favoriteListVC)

        self.viewControllers = [recipeListNav, favoriteListNav]
        self.selectedIndex = 0
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
