//
//  ViewController.swift
//  CommonUI
//
//  Created by Yurii Dukhovnyi on 16.11.2022.
//

import UIKit

/// Defines base class for creation view controller, deprecates `init?(coder:)` initializer.
///
open class ViewController<T: View>: UIViewController {

    public var contentView: T {
        view as! T
    }

    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func loadView() {
        view = T()
    }
}
