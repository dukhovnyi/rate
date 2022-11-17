//
//  Currency.swift
//  CalculatorSDK
//
//  Created by Yurii Dukhovnyi on 16.11.2022.
//

import Foundation

extension Calculator {

    public struct Currency {

        public let name: String
        public let img: String
        public let code: String
        public let sending: ClosedRange<UInt>
        public let receiving: ClosedRange<UInt>
        public let defaultSending: UInt

        public init(
            name: String,
            img: String,
            code: String,
            sending: ClosedRange<UInt>,
            receiving: ClosedRange<UInt>,
            defaultSending: UInt
        ) {
            self.name = name
            self.img = img
            self.code = code
            self.sending = sending
            self.receiving = receiving
            self.defaultSending = defaultSending
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
        self.defaultSending = try container.decode(UInt.self, forKey: .defaultSending)

        receiving = try Self.decodeRange(
            container: container.nestedContainer(keyedBy: RangeKeys.self, forKey: .receiving)
        )
        sending = try Self.decodeRange(
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
        try receivingContainer.encode(receiving.lowerBound, forKey: .from)
        try receivingContainer.encodeIfPresent(receiving.upperBound == UInt.max ? nil : receiving.upperBound, forKey: .to)

        var sendingContainer = container.nestedContainer(keyedBy: RangeKeys.self, forKey: .sending)
        try sendingContainer.encode(sending.lowerBound, forKey: .from)
        try sendingContainer.encodeIfPresent(sending.upperBound == UInt.max ? nil : sending.upperBound, forKey: .to)
    }

    // MARK: - Private

    private static func decodeRange(container: KeyedDecodingContainer<RangeKeys>) throws -> ClosedRange<UInt> {

        let lowerBound = try container.decode(UInt.self, forKey: .from)
        let upperBound = try container.decodeIfPresent(UInt.self, forKey: .to)

        return lowerBound ... (upperBound ?? UInt.max)
    }
}
