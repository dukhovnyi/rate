//
//  ApiRequestTests.swift
//  CommonKitTests
//
//  Created by Yurii Dukhovnyi on 18.11.2022.
//

import XCTest
@testable import CommonKit

final class ApiRequestTests: XCTestCase {

    struct NonCodsableObj {}
    struct CodableObj: Decodable {
        let propA: String
        let propB: String
    }

    func testRequest__validCodableResponse() throws {

        let req = Api.Request<CodableObj>(
            .get,
            endpoint: .relative("/codable/api")
        )

        XCTAssertNoThrow(
            try req.responseDecoder(
                Data(#"{ "propA": "A", "propB": "B" }"#.utf8), .
                init()
            )
        )
    }

    func testRequest__notValidCodableResponse() throws {

        let req = Api.Request<CodableObj>(
            .get,
            endpoint: .relative("/codable/api")
        )

        XCTAssertThrowsError(
            try req.responseDecoder(
                Data("{}".utf8), .
                init()
            )
        )
    }

    func testRequest__ignoreResponse() throws {

        let req = Api.Request<Void>(
            .get,
            endpoint: .relative("/codable/api")
        )

        XCTAssertNoThrow(
            try req.responseDecoder(
                Data("~".utf8), .
                init()
            )
        )
    }
}
