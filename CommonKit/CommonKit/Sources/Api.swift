//
//  Api.swift
//  CommonKit
//
//  Created by Yurii Dukhovnyi on 18.11.2022.
//

import Foundation

/// Namespace for API related mechanisms.
///
public enum Api {

    /// HTTP headers.
    ///
    public typealias Headers = [String: String]?

    /// Generic response decoder.
    ///
    public typealias ResponseDecoder<R> = (_ data: Data, _ httpResponse: HTTPURLResponse) throws -> R

    /// HTTP method for API request.
    ///
    public enum HttpMethod: String { case get, post, put, update, delete }

    /// API request endpoint.
    ///
    public enum Endpoint {

        /// Path relative to API base URL.
        ///
        case relative(_ path: String)

        /// Absolute path including query items.
        ///
        case absolute(_ url: URL)
    }

    public enum Error: Swift.Error {
        case unknownResponse(URLResponse?)
    }

    static func makeUrlRequest<R>(
        with apiRequest: Api.Request<R>,
        baseUrl: URL
    ) -> URLRequest {

        var components: URLComponents?
        switch apiRequest.endpoint {
        case .absolute(let url):
            components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        case .relative(let path):
            components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: false)
            components?.path = path
        }

        components?.queryItems = apiRequest.query

        var urlRequest = URLRequest(url: components?.url ?? baseUrl)
        urlRequest.httpMethod = apiRequest.method.rawValue
        urlRequest.allHTTPHeaderFields = apiRequest.headers
        urlRequest.httpBody = apiRequest.httpBody

        return urlRequest
    }

}
