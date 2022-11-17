//
//  FxRate.swift
//  CalculatorSDK
//
//  Created by Yurii Dukhovnyi on 17.11.2022.
//

import Foundation

extension Calculator {

    public struct FxRate: Decodable {

        public let from: String
        public let to: String
        public let rate: Float
        public let fromAmount: Float
        public let toAmount: Float
    }
}
