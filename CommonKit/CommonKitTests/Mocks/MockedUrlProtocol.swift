//
//  MockedUrlProtocol.swift
//  CommonKitTests
//
//  Created by Yurii Dukhovnyi on 18.11.2022.
//

import Foundation

var urlProtocolMocks = [MockedUrlProtocol.Mock]()

final class MockedUrlProtocol: URLProtocol {

    override class func canInit(with task: URLSessionTask) -> Bool {
        true
    }

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func stopLoading() {
        print(#function)
    }

    override func startLoading() {

        guard
            let mock = urlProtocolMocks.first(where: { $0.validate(request) })
        else {
            return
        }

        client?.urlProtocol(
            self,
            didLoad: mock.data
        )
        client?.urlProtocol(
            self,
            didReceive: mock.http,
            cacheStoragePolicy: .allowed
        )
        client?.urlProtocolDidFinishLoading(self) 
    }
}

extension MockedUrlProtocol {

    struct Mock {
        let validate: (URLRequest) -> Bool
        let data: Data
        var http: HTTPURLResponse = .init()
    }
}
