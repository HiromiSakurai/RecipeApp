//
//  Rx+extension.swift
//  RecipeAppKit
//
//  Created by Hiromi Sakurai on 2020/05/17.
//  Copyright © 2020 HiromiSakurai. All rights reserved.
//

import Foundation
import RxRelay

/// valueがread-onlyのため、writeを簡略化するためのutility
public extension BehaviorRelay where Element: Any {
    var mutableValue: Element {
        set {
            self.accept(newValue)
        }
        get {
            return self.value
        }
    }
}
