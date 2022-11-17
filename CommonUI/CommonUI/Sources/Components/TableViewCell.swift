//
//  TableViewCell.swift
//  CommonUI
//
//  Created by Yurii Dukhovnyi on 17.11.2022.
//

import UIKit

/// Defines base class for ``UITableViewCell``, deprecates `init?(coder:)` initializer.
/// 
open class TableViewCell: UITableViewCell {

    public init(reuseIdentifier: String) {
        super.init(
            style: .default,
            reuseIdentifier: reuseIdentifier
        )
        setup()
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func updateConstraints() {
        if needsToDefineLayout {
            needsToDefineLayout = false
            defineLayout()
        }
        super.updateConstraints()
    }

    open func setup() {}
    open func defineLayout() {}

    // MARK: - Private

    private var needsToDefineLayout = true
}
