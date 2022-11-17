//
//  Makeable.swift
//  CommonUI
//
//  Created by Yurii Dukhovnyi on 16.11.2022.
//

import UIKit

/// Provides mechanism for easiest way to do pre-setup object.
public protocol Makeable {}

extension Makeable where Self: UIView {

    public func make(
        _ configuration: (Self) -> Void
    ) -> Self {

        configuration(self)
        return self
    }
}

// Injects `make` functions to `UIView`.
extension UIView: Makeable {}
