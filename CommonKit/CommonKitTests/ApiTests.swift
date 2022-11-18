//
//  CommonKitTests.swift
//  CommonKitTests
//
//  Created by Yurii Dukhovnyi on 18.11.2022.
//

import XCTest
@testable import CommonKit

final class ApiTests: XCTestCase {

    private let mock = (
        absoluteUrl: URL(string: "https://api.name.com/some/path")!,
        baseUrl: URL(string: "https://api.name.com")!,
        path: "/some/path",
        queryString: "q=queryValue",
        httpHeaders: [
            "ContentType": "json",
            "Authorization": "Bearer 5d902d650f881d2fcf270cc0066bb8a965ef51b3"
        ],
        body: "{}".data(using: .utf8)
    )

    func testMakeUrlRequest__withAbsoluteUrl() throws {

        let req = Api.Request(
            .get,
            endpoint: .absolute(mock.absoluteUrl),
            query: [
                .init(name: "q", value: "queryValue")
            ]
        )

        let testedUrlRequest = Api.makeUrlRequest(
            with: req,
            baseUrl: mock.baseUrl
        )

        XCTAssertEqual(
            testedUrlRequest.url?.absoluteString,
            mock.absoluteUrl.absoluteString + "?\(mock.queryString)"
        )
    }

    func testMakeUrlRequest__withRelativeUrl() throws {

        let req = Api.Request(
            .get,
            endpoint: .relative(mock.path),
            query: [
                .init(name: "q", value: "queryValue")
            ]
        )

        let testedUrlRequest = Api.makeUrlRequest(
            with: req,
            baseUrl: mock.baseUrl
        )

        XCTAssertEqual(
            testedUrlRequest.url?.absoluteString,
            mock.baseUrl.absoluteString + mock.path + "?\(mock.queryString)"
        )

        XCTAssertEqual(
            testedUrlRequest.httpMethod?.uppercased(),
            req.method.rawValue.uppercased()
        )
    }

    func testMakeUrlRequest__httpMethodGet() throws {

        let req = Api.Request(
            .get,
            endpoint: .absolute(mock.absoluteUrl)
        )

        let testedUrlRequest = Api.makeUrlRequest(
            with: req,
            baseUrl: mock.baseUrl
        )

        XCTAssertEqual(
            testedUrlRequest.httpMethod?.uppercased(),
            req.method.rawValue.uppercased()
        )
    }

    func testMakeUrlRequest__httpMethodPost() throws {

        let req = Api.Request(
            .post,
            endpoint: .absolute(mock.absoluteUrl)
        )

        let testedUrlRequest = Api.makeUrlRequest(
            with: req,
            baseUrl: mock.baseUrl
        )

        XCTAssertEqual(
            testedUrlRequest.httpMethod?.uppercased(),
            req.method.rawValue.uppercased()
        )
    }

    func testMakeUrlRequest__httpHeaders() throws {

        let req = Api.Request(
            .get,
            endpoint: .absolute(mock.absoluteUrl),
            headers: mock.httpHeaders
        )

        let testedUrlRequest = Api.makeUrlRequest(
            with: req,
            baseUrl: mock.baseUrl
        )

        XCTAssertEqual(
            testedUrlRequest.allHTTPHeaderFields,
            req.headers
        )
    }

    func testMakeUrlRequest__httpBody() throws {

        let req = Api.Request(
            .get,
            endpoint: .absolute(mock.absoluteUrl),
            httpBody: mock.body
        )

        let testedUrlRequest = Api.makeUrlRequest(
            with: req,
            baseUrl: mock.baseUrl
        )

        XCTAssertEqual(
            testedUrlRequest.httpBody,
            req.httpBody
        )
    }
}
