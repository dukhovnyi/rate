//
//  ApiClient.swift
//  CommonKit
//
//  Created by Yurii Dukhovnyi on 18.11.2022.
//

import Foundation

public protocol ApiClient {

    func request<R>(
        _ req: Api.Request<R>,
        onComplete: @escaping (_ result: Result<R, Error>) -> Void
    ) -> Api.Cancellable
}

extension Api {

    public typealias Cancellable = () -> Void

    public class Live: ApiClient {

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

            let urlRequest = makeUrlRequest(with: req, baseUrl: baseUrl)
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

        private func makeUrlRequest<R>(
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

            return urlRequest
        }
    }
}
