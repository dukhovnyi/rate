//
//  UIStackView.Extensions.swift
//  CommonUI
//
//  Created by Yurii Dukhovnyi on 16.11.2022.
//

import UIKit

extension UIStackView {

    /// Creates ``UIStackView`` in declarative manear.
    ///
    public static func make(
        _ axis: NSLayoutConstraint.Axis,
        spacing: CGFloat = 0,
        distribution: UIStackView.Distribution = .fill,
        alignment: UIStackView.Alignment = .fill
    ) -> (UIView...) -> UIStackView {

        { (views: UIView...) -> UIStackView in
            createStackView(
                axis,
                spacing: spacing,
                distribution: distribution,
                alignment: alignment,
                subviews: views
            )
        }
    }

    /// Creates ``UIStackView`` in declarative manear.
    ///
    public static func make(
        _ axis: NSLayoutConstraint.Axis,
        spacing: CGFloat = 0,
        distribution: UIStackView.Distribution = .fill,
        alignment: UIStackView.Alignment = .fill
    ) -> ([UIView]) -> UIStackView {

        { (views: [UIView]) -> UIStackView in
            createStackView(
                axis,
                spacing: spacing,
                distribution: distribution,
                alignment: alignment,
                subviews: views
            )
        }
    }

    // MARK: - Private

    private static func createStackView(
        _ axis: NSLayoutConstraint.Axis,
        spacing: CGFloat = 0,
        distribution: UIStackView.Distribution = .fill,
        alignment: UIStackView.Alignment = .fill,
        subviews: [UIView]
    ) -> UIStackView {

        let stack = UIStackView(arrangedSubviews: subviews)

        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = axis
        stack.spacing = spacing
        stack.distribution = distribution
        stack.alignment = alignment

        return stack
    }
}
