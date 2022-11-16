//
//  View.swift
//  CommonUI
//
//  Created by Yurii Dukhovnyi on 16.11.2022.
//

import UIKit

open class View: UIView {

    required public init() {
        super.init(frame: .zero)
        setup()
        defineLayout()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        defineLayout()
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func setup() {}
    open func defineLayout() {}
}
