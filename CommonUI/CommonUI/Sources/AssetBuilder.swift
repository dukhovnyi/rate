//
//  AssetBuilder.swift
//  CommonUI
//
//  Created by Yurii Dukhovnyi on 16.11.2022.
//

import UIKit

/// Defines mechanism for injection assets to SDK/frameworks.
///
public struct AssetBuilder {

    ///
    ///
    public init(
        fontBuilder: @escaping (FontFace, CGFloat) -> UIFont,
        imageBuilder: @escaping (String) -> UIImage?
    ) {
        self.fontBuilder = fontBuilder
        self.imageBuilder = imageBuilder
    }

    /// Creates ``UIFont`` instance based on face and size.
    ///
    public func font(
        face: FontFace,
        size: CGFloat
    ) -> UIFont {

        fontBuilder(face, size)
    }

    /// Creates ``UIImage`` instance based on face and size.
    ///
    public func image(
        name: String
    ) -> UIImage? {

        imageBuilder(name)
    }

    // MARK: - Private

    private let fontBuilder: (FontFace, CGFloat) -> UIFont
    private let imageBuilder: (String) -> UIImage?
}

extension AssetBuilder {

    public enum FontFace {
        case regular, bold
    }
}
