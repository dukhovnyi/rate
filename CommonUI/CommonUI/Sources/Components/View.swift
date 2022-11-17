//
//  View.swift
//  CommonUI
//
//  Created by Yurii Dukhovnyi on 16.11.2022.
//

import UIKit

/// Defines base class for creation view, deprecates `init?(coder:)` initializer.
/// 
open class View: UIView {

    required public init() {
        super.init(frame: .zero)
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func updateConstraints() {
        super.updateConstraints()

        if needsToDefineLayout {
            needsToDefineLayout = false
            defineLayout()
        }
    }

    open func setup() {}
    open func defineLayout() {}

    // MARK: - Private

    private var needsToDefineLayout = true
}
