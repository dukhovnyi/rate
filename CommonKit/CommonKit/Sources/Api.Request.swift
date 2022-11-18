//
//  Api.Request.swift
//  CommonKit
//
//  Created by Yurii Dukhovnyi on 18.11.2022.
//

import Foundation

public extension Api {

    /// Defines API requests and decoder for response.
    /// 
    struct Request<Response> {
        public let method: HttpMethod
        public let endpoint: Endpoint
        public let query: [URLQueryItem]
        public let headers: Headers
        public let httpBody: Data?
        public let responseDecoder: ResponseDecoder<Response>

        init(
            _ method: HttpMethod,
            endpoint: Endpoint,
            query: [URLQueryItem] = [],
            headers: Headers = [:],
            httpBody: Data? = nil,
            responseDecoder: @escaping ResponseDecoder<Response>
        ) {
            self.method = method
            self.endpoint = endpoint
            self.query = query
            self.headers = headers
            self.httpBody = httpBody
            self.responseDecoder = responseDecoder
        }
    }
}

public extension Api.Request where Response == Void {

    init(
        _ method: Api.HttpMethod,
        endpoint: Api.Endpoint,
        query: [URLQueryItem] = [],
        headers: Api.Headers = [:],
        httpBody: Data? = nil) {

        self.init(
            method,
            endpoint: endpoint,
            query: query,
            headers: headers,
            httpBody: httpBody,
            responseDecoder: { _, _ in return }
        )
    }
}

public extension Api.Request where Response: Decodable {

    init(
        _ method: Api.HttpMethod,
        endpoint: Api.Endpoint,
        query: [URLQueryItem] = [],
        headers: Api.Headers = [:],
        httpBody: Data? = nil,
        jsonDecoder: JSONDecoder = .init()) {

        self.init(
            method,
            endpoint: endpoint,
            query: query,
            headers: headers,
            httpBody: httpBody,
            responseDecoder: { data, _ in
                return try jsonDecoder.decode(Response.self, from: data)
        })
    }
}
