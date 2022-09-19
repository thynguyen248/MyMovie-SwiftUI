//
//  APIManager.swift
//  MyMovie-SwiftUI
//
//  Created by Thy Nguyen on 4/30/20.
//  Copyright © 2020 Thy Nguyen. All rights reserved.
//

import Foundation
import Combine

class APIManager {
    static let shared = APIManager()
    private let session: URLSession
    private init(session: URLSession = .shared) {
        self.session = session
    }
    
    func getMovies(type: HomeSectionType, page: Int) -> AnyPublisher<MovieResponseModel, MovieError> {
        return getMovies(components: getMoviesURLComponents(type: type, page: page))
    }
    
    func getMovieDetail(movieId: Int) -> AnyPublisher<MovieDetailModel, MovieError> {
        return getMovieDetail(components: getMovieDetailURLComponents(movieId: movieId))
    }
    
    private func getMovies(components: URLComponents
    ) -> AnyPublisher<MovieResponseModel, MovieError> {
        guard let url = components.url else {
            let error = MovieError.network(description: "Couldn't create URL")
            return Fail(error: error).eraseToAnyPublisher()
        }
        return session.dataTaskPublisher(for: URLRequest(url: url))
            .mapError { error in
                .network(description: error.localizedDescription)
        }
        .flatMap(maxPublishers: .max(1), { data, response in
            decode(data)
        })
//            .tryMap { data, response in
//                do {
//                    return try JSONDecoder().decode(MovieResponseModel.self, from: data)
//                } catch {
//                    throw(error)
//                }
//        }
//        .mapError { error in
//            .network(description: error.localizedDescription)
//        }
            .eraseToAnyPublisher()
    }
    
    private func getMovieDetail(components: URLComponents
    ) -> AnyPublisher<MovieDetailModel, MovieError> {
        guard let url = components.url else {
            let error = MovieError.network(description: "Couldn't create URL")
            return Fail(error: error).eraseToAnyPublisher()
        }
        return session.dataTaskPublisher(for: URLRequest(url: url))
            .mapError { error in
                .network(description: error.localizedDescription)
        }
        .flatMap(maxPublishers: .max(1), { data, response in
            decode(data)
        })
            .eraseToAnyPublisher()
    }
}

extension APIManager {
    struct MovieAPI {
        static let scheme = "https"
        static let host = "api.themoviedb.org"
        static let path = "/3"
        static let key = "7a20b718d2507f11dad2d84d6b028fdd"
    }
    
    private func getMoviesURLComponents(type: HomeSectionType, page: Int) -> URLComponents {
        var components = URLComponents()
        components.scheme = MovieAPI.scheme
        components.host = MovieAPI.host
        
        switch type {
        case .popular:
            components.path = MovieAPI.path + "/movie/popular"
        case .topRated:
            components.path = MovieAPI.path + "/movie/top_rated"
        case .upcoming:
            components.path = MovieAPI.path + "/movie/upcoming"
        default:
            break
        }
        
        components.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "api_key", value: MovieAPI.key)
        ]
        
        return components
    }
    
    private func getMovieDetailURLComponents(movieId: Int) -> URLComponents {
        var components = URLComponents()
        components.scheme = MovieAPI.scheme
        components.host = MovieAPI.host
        components.path = MovieAPI.path + "/movie/\(movieId)"
        
        components.queryItems = [
            URLQueryItem(name: "append_to_response", value: "videos,recommendations"),
            URLQueryItem(name: "api_key", value: MovieAPI.key)
        ]
        
        return components
    }
}

enum MovieError: Error {
    case parsing(description: String)
    case network(description: String)
}
