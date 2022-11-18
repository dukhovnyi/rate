//
//  Api.swift
//  CommonKit
//
//  Created by Yurii Dukhovnyi on 18.11.2022.
//

import Foundation

public enum Api {

    public typealias Headers = [String: String?]
    public typealias ResponseDecoder<R> = (_ data: Data, _ httpResponse: HTTPURLResponse) throws -> R

    public enum HttpMethod: String { case get, post, put, update, delete }

    public enum Endpoint {
        case relative(_ path: String)
        case absolute(_ url: URL)
    }

    public enum Error: Swift.Error {
        case unknownResponse(URLResponse?)
    }
}
