//
//  AlertShowable.swift
//  RecipeApp
//
//  Created by Hiromi Sakurai on 2020/05/18.
//  Copyright © 2020 HiromiSakurai. All rights reserved.
//

import Foundation
import UIKit

protocol AlertShowable {
    func showSimpleAlert(with message: String)
}

extension AlertShowable where Self: UIViewController {
    func showSimpleAlert(with message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}
