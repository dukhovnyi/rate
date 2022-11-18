//
//  ApiClientTests.swift
//  CommonKitTests
//
//  Created by Yurii Dukhovnyi on 18.11.2022.
//

import XCTest
@testable import CommonKit

final class ApiClientTests: XCTestCase {

    struct DecodableObj: Equatable, Decodable { let prop: String }

    private let mock = (
        baseUrl: URL(string: "https://api.name.com")!,
        validJsonData: Data(#"{ "prop": "i'm mocked value" }"#.utf8)
    )

    lazy var testedApiClient: Api.Live = {

        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses?.insert(MockedUrlProtocol.self, at: 0)

        return Api.Live(
            baseUrl: mock.baseUrl,
            urlSession: URLSession(configuration: configuration)
        )
    }()

    override class func setUp() {
        urlProtocolMocks = []
        super.setUp()
    }

    func testRequest__mockedResponse() throws {

        let path = "/testRequest__mockedResponse"
        let req = Api.Request<DecodableObj>(
            .get,
            endpoint: .relative(path)
        )

        urlProtocolMocks.append(
            MockedUrlProtocol.Mock(
                validate: {
                    $0.url?.relativePath == path
                },
                data: mock.validJsonData
            )
        )

        let exp = expectation(description: "Network request from mocked URLProtocol.")

        testedApiClient.request(req) { result in
            do {
                let resp = try result.get()
                XCTAssertEqual(resp, .init(prop: "i'm mocked value"))
                exp.fulfill()
            } catch {
                XCTFail(error.localizedDescription)
            }
        }
        wait(for: [exp], timeout: 1.0)
    }

    func testRequest__mockedInvalidResponse() throws {

        let path = "/testRequest__mockedInvalidResponse"
        let req = Api.Request<DecodableObj>(
            .get,
            endpoint: .relative(path)
        )

        urlProtocolMocks.append(
            MockedUrlProtocol.Mock(
                validate: { $0.url?.relativePath == path },
                data: Data()
            )
        )

        let exp = expectation(description: "Network request from mocked URLProtocol.")

        testedApiClient.request(req) { result in
            guard
                case .failure(let error) = result
            else {
                XCTFail("Expects decoding error.")
                return
            }
            XCTAssertTrue(error is DecodingError)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
}
