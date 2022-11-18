//
//  ApiRequestBuilder.swift
//  App
//
//  Created by Yurii Dukhovnyi on 18.11.2022.
//

import CalculatorSDK
import CommonKit
import Foundation

enum ApiRequestBuilder {

    static func fxRate(
        from: String,
        to: String,
        amount: Float
    ) -> Api.Request<Calculator.FxRate> {

        .init(
            .get,
            endpoint: .relative("/api/fx-rates"),
            query: [
                .init(name: "from", value: from),
                .init(name: "to", value: to),
                .init(name: "amount", value: "\(amount)")
            ]
        )
    }
}
