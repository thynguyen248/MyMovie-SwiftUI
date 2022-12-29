//
//  APIClient.swift
//  MyMovie-SwiftUI
//
//  Created by Thy Nguyen on 12/26/22.
//  Copyright © 2022 Thy Nguyen. All rights reserved.
//

import Combine
import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum NetworkRequestError: LocalizedError, Equatable {
    case invalidRequest
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case error4xx(_ code: Int)
    case serverError
    case error5xx(_ code: Int)
    case decodingError(_ message: String)
    case urlSessionFailed(_ error: URLError)
    case unknownError
}

protocol Request {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var contentType: String { get }
    var queryParams: [String: Any]? { get }
    var body: [String: Any]? { get }
    var headers: [String: String]? { get }
    associatedtype ReturnType: Decodable
}

extension Request {
    var baseURL: String { return APIConstants.baseURL }
    var method: HTTPMethod { return .get }
    var contentType: String { return "application/json" }
    var queryParams: [String: Any]? { return nil }
    var body: [String: Any]? { return nil }
    var headers: [String: String]? { return nil }
    
    private func requestBodyFrom(params: [String: Any]?) -> Data? {
        guard let params = params else { return nil }
        guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else {
            return nil
        }
        return httpBody
    }
    
    var urlRequest: URLRequest? {
        guard var urlComponents = URLComponents(string: baseURL) else { return nil }
        urlComponents.path = "\(urlComponents.path)\(path)"
        
        var queryDic: [String: Any] = queryParams ?? [:]
        queryDic["api_key"] = APIConstants.key
        let queryItems = queryDic.map {
            return URLQueryItem(name: "\($0)", value: "\($1)")
        }
        urlComponents.queryItems = queryItems
        
        guard let finalURL = urlComponents.url else { return nil }
        var request = URLRequest(url: finalURL)
        request.httpMethod = method.rawValue
        request.httpBody = requestBodyFrom(params: body)
        request.allHTTPHeaderFields = headers
        return request
    }
}

struct APIConstants {
    static let baseURL = "https://api.themoviedb.org/3"
    static let key = "7a20b718d2507f11dad2d84d6b028fdd"
}

final class APIClient {
    private let urlSession: URLSession
    private let decoder: JSONDecoder
    
    init(urlSession: URLSession = URLSession.shared,
         decoder: JSONDecoder = JSONDecoder()) {
        self.urlSession = urlSession
        self.decoder = decoder
    }
    
    func request<R: Request>(_ request: R) -> AnyPublisher<R.ReturnType, NetworkRequestError> {
        guard let urlRequest = request.urlRequest else {
            return Fail(outputType: R.ReturnType.self, failure: NetworkRequestError.badRequest).eraseToAnyPublisher()
        }
        return urlSession.dataTaskPublisher(for: urlRequest)
            .tryMap { [weak self] (data, response) in
                if let response = response as? HTTPURLResponse,
                   !((200...299).contains(response.statusCode)) {
                    throw self?.httpError(response.statusCode) ?? NetworkRequestError.unknownError
                }
                return data
            }
            .decode(type: R.ReturnType.self, decoder: decoder)
            .mapError({ [weak self] error in
                self?.handleError(error) ?? NetworkRequestError.unknownError
            })
            .eraseToAnyPublisher()
    }
    
    private func httpError(_ statusCode: Int) -> NetworkRequestError {
        switch statusCode {
        case 400: return .badRequest
        case 401: return .unauthorized
        case 403: return .forbidden
        case 404: return .notFound
        case 402, 405...499: return .error4xx(statusCode)
        case 500: return .serverError
        case 501...599: return .error5xx(statusCode)
        default: return .unknownError
        }
    }
    
    private func handleError(_ error: Error) -> NetworkRequestError {
        switch error {
        case is Swift.DecodingError:
            return .decodingError(error.localizedDescription)
        case let urlError as URLError:
            return .urlSessionFailed(urlError)
        case let error as NetworkRequestError:
            return error
        default:
            return .unknownError
        }
    }
}
