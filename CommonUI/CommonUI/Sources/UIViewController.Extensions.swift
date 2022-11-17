//
//  UIViewController.Extensions.swift
//  CommonUI
//
//  Created by Yurii Dukhovnyi on 17.11.2022.
//

import UIKit

extension UIViewController {

    public func add(viewController: UIViewController, toContainer: UIView? = nil) {

        viewController.willMove(toParent: self); defer { viewController.didMove(toParent: self) }
        addChild(viewController)
        (toContainer ?? view).addSubview(viewController.view)
        viewController.view.layoutInSuperview().activate()
    }

    public func remove() {
        // Just to be safe, we check that this view controller
        // is actually added to a parent before removing it.
        guard parent != nil else { return }

        willMove(toParent: nil); defer { didMove(toParent: nil) }

        view.removeFromSuperview()
        removeFromParent()
    }
}
