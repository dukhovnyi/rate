//
//  Calculator.swift
//  CalculatorSDK
//
//  Created by Yurii Dukhovnyi on 16.11.2022.
//

import CommonUI
import UIKit

/// The main SDK namespace for CalculatorSDK.
///
public final class Calculator {

    public init() {}

    public func makeSendingViewController() -> SendingViewController {
        SendingViewController()
    }
}

extension Calculator {

    /// Registers global ``AssetBuilder`` for the SDK.
    /// 
    public static func register(
        assetBuilder newAssetBuilder: AssetBuilder
    ) {
        assetBuilder = newAssetBuilder
    }
}

var assetBuilder = AssetBuilder(
    fontBuilder: { face, size in
        switch face {
        case .regular:
            return .systemFont(ofSize: size)
        case .bold:
            return .boldSystemFont(ofSize: size)
        }
    },
    imageBuilder: { name in
        UIImage(named: name)
    })
