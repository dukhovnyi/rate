//
//  ViewController.swift
//  CommonUI
//
//  Created by Yurii Dukhovnyi on 16.11.2022.
//

import UIKit

open class ViewController<T: View>: UIViewController {
    var contentView: T {
        view as! T
    }

    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func loadView() {
        view = T()
    }
}
