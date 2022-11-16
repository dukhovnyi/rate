//
//  Makeable.swift
//  CommonUI
//
//  Created by Yurii Dukhovnyi on 16.11.2022.
//

import UIKit

public protocol Makeable {}

extension Makeable where Self: UIView {

    public func make(
        _ configuration: (Self) -> Void
    ) -> Self {

        configuration(self)
        return self
    }
}

extension UIView: Makeable {}
