//
//  Currency.swift
//  CalculatorSDK
//
//  Created by Yurii Dukhovnyi on 16.11.2022.
//

import Foundation

extension Calculator {

    public struct Currency: Equatable {

        public let name: String
        public let img: String
        public let code: String
        public let sendingLimits: ClosedRange<Float>
        public let receivingLimits: ClosedRange<Float>
        public let defaultSending: Float

        public init(
            name: String,
            img: String,
            code: String,
            sendingLimits: ClosedRange<Float>,
            receivingLimits: ClosedRange<Float>,
            defaultSending: Float
        ) {
            self.name = name
            self.img = img
            self.code = code
            self.sendingLimits = sendingLimits
            self.receivingLimits = receivingLimits
            self.defaultSending = defaultSending
        }

        public static func mock (
            name: String = "",
            img: String = "",
            code: String = "",
            sendingLimits: ClosedRange<Float> = 0 ... 100,
            receivingLimits: ClosedRange<Float> = 0 ... 100,
            defaulSending: Float = 1
        ) -> Self {

            .init(
                name: name,
                img: img,
                code: code,
                sendingLimits: sendingLimits,
                receivingLimits: receivingLimits,
                defaultSending: defaulSending
            )
        }
    }
}

extension [Calculator.Currency] {

    public static let mock: Self = {
        guard
            let url = Bundle(for: Calculator.self).url(forResource: "mock", withExtension: "json"),
            let jsonData = try? Data(contentsOf: url),
            let currencies = try? JSONDecoder().decode([Calculator.Currency].self, from: jsonData)
        else {
            assertionFailure("Currency mock file is missed or has incorrect format.")
            return []
        }

        return currencies
    }()
}

extension Calculator.Currency: Codable {

    enum CodingKeys: String, CodingKey {
        case name, img, code, sending, receiving, defaultSending
    }
    enum RangeKeys: String, CodingKey {
        case from, to
    }

    public init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.img = try container.decode(String.self, forKey: .img)
        self.code = try container.decode(String.self, forKey: .code)
        self.defaultSending = try container.decode(Float.self, forKey: .defaultSending)

        receivingLimits = try Self.decodeRange(
            container: container.nestedContainer(keyedBy: RangeKeys.self, forKey: .receiving)
        )
        sendingLimits = try Self.decodeRange(
            container: container.nestedContainer(keyedBy: RangeKeys.self, forKey: .sending)
        )
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(img, forKey: .img)
        try container.encode(code, forKey: .code)
        try container.encode(defaultSending, forKey: .defaultSending)

        var receivingContainer = container.nestedContainer(keyedBy: RangeKeys.self, forKey: .receiving)
        try receivingContainer.encode(receivingLimits.lowerBound, forKey: .from)
        try receivingContainer.encodeIfPresent(receivingLimits.upperBound == Float.infinity ? nil : receivingLimits.upperBound, forKey: .to)

        var sendingContainer = container.nestedContainer(keyedBy: RangeKeys.self, forKey: .sending)
        try sendingContainer.encode(sendingLimits.lowerBound, forKey: .from)
        try sendingContainer.encodeIfPresent(sendingLimits.upperBound == Float.infinity ? nil : sendingLimits.upperBound, forKey: .to)
    }

    // MARK: - Private

    private static func decodeRange(container: KeyedDecodingContainer<RangeKeys>) throws -> ClosedRange<Float> {

        let lowerBound = try container.decode(Float.self, forKey: .from)
        let upperBound = try container.decodeIfPresent(Float.self, forKey: .to)

        return lowerBound ... (upperBound ?? Float.infinity)
    }
}
