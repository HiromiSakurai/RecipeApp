//
//  SceneDelegate.swift
//  RecipeApp
//
//  Created by 櫻井寛海 on 2020/05/12.
//  Copyright © 2020 HiromiSakurai. All rights reserved.
//

import UIKit
import RecipeAppKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene

        let favoriteModel = FavoriteModelImpl()

        let recipeListVM = RecipeListViewModelImpl(recipeModel: RecipeModelImpl(), favoriteModel: favoriteModel)
        let recipeListVC = RecipeListViewController(viewModel: recipeListVM)

        let favoriteListVM = FavoriteListViewModelImpl(favoriteModel: favoriteModel)
        let favoriteListVC = FavoriteListViewController(viewModel: favoriteListVM)

        let tabBarController = RecipeAppTabBarController(recipeListVC: recipeListVC, favoriteListVC: favoriteListVC)

        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}

