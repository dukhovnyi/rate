//
//  UIFont.InterFontFamily.swift
//  App
//
//  Created by Yurii Dukhovnyi on 16.11.2022.
//

import CommonUI
import UIKit

extension UIFont {

    static func interOrDefault(
        face: InterFontFace,
        size: CGFloat
    ) -> UIFont {
        
        let interFont = UIFont(
            name: face.rawValue,
            size: size
        )
        assert(interFont != nil)

        return interFont ?? UIFont.systemFont(ofSize: size)
    }

    // MARK: - Private

    enum InterFontFace: String {
        case regular = "Inter-Regular"
        case bold = "Inter-Bold"
    }
}

extension AssetBuilder {

    static func `default`() -> Self {

        .init(
            fontBuilder: { face, size in

                switch face {

                case .regular:
                    return .interOrDefault(face: .regular, size: size)

                case .bold:
                    return .interOrDefault(face: .bold, size: size)
                }

            },
            imageBuilder: { name in

                UIImage(named: name)

            })
    }
}
