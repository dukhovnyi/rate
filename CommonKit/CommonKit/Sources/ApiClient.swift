//
//  ApiClient.swift
//  CommonKit
//
//  Created by Yurii Dukhovnyi on 18.11.2022.
//

import Foundation

/// Network client for interaction with API.
///
public protocol ApiClient {

    /// Sends generic API request.
    ///
    func request<R>(
        _ req: Api.Request<R>,
        onComplete: @escaping (_ result: Result<R, Error>) -> Void
    ) -> Api.Cancellable
}

extension Api {

    /// Cancells network operation.
    ///
    public typealias Cancellable = () -> Void

    /// Live implementation of network client.
    ///
    public class Live: ApiClient {

        /// Construct live network client.
        ///
        /// - Parameters:
        ///   - baseUrl: used for building Api requests with relative endpoints.
        ///   - urlSession: instanse of URLSession that used to create data tasks.
        ///   
        public init(
            baseUrl: URL,
            urlSession: URLSession = .shared
        ) {
            self.baseUrl = baseUrl
            self.urlSession = urlSession
        }

        @discardableResult
        public func request<R>(
            _ req: Api.Request<R>,
            onComplete: @escaping (Result<R, Swift.Error>) -> Void
        ) -> Api.Cancellable {

            let urlRequest = Api.makeUrlRequest(with: req, baseUrl: baseUrl)
            let dataTask = urlSession.dataTask(
                with: urlRequest
            ) { data, urlResponse, error in

                guard
                    let http = urlResponse as? HTTPURLResponse
                else {
                    onComplete(.failure(Api.Error.unknownResponse(urlResponse)))
                    return
                }

                do {
                    let resp = try req.responseDecoder(data ?? Data(), http)
                    onComplete(.success(resp))
                } catch {
                    onComplete(.failure(error))
                }
            }

            defer { dataTask.resume() }

            return { dataTask.cancel() }
        }

        // MARK: - Private

        private let baseUrl: URL
        private let urlSession: URLSession
    }
}
