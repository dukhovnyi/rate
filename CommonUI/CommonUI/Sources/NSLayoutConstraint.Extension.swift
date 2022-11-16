//
//  NSLayoutConstraint.Extension.swift
//  CommonUI
//
//  Created by Yurii Dukhovnyi on 16.11.2022.
//

import UIKit

extension Array where Element == NSLayoutConstraint {

    public func activate() {
        NSLayoutConstraint.activate(self)
    }

    public func deactivate() {
        NSLayoutConstraint.deactivate(self)
    }

    public static func +=(
        destination: inout [NSLayoutConstraint],
        newConstraint: NSLayoutConstraint
    ) {
        destination.append(newConstraint)
    }

    public func constraints(with id: NSLayoutConstraint.Identifier) -> [NSLayoutConstraint] {
        filter { $0.identifier == id.rawValue }
    }
}

extension NSLayoutConstraint {

    public enum Identifier: String {
        case leading, top, trailing, bottom, width, height, greaterThanTop, lessThanBottom
    }

    public func priority(_ newValue: UILayoutPriority) -> Self {
        priority = newValue
        return self
    }

    public func identifier(_ id: Identifier) -> Self {
        identifier = id.rawValue
        return self
    }
}

