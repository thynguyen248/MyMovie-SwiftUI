//
//  APIClient+movies.swift
//  MyMovie-SwiftUI
//
//  Created by Thy Nguyen on 12/27/22.
//  Copyright © 2022 Thy Nguyen. All rights reserved.
//

import Combine

enum MovieListType: String {
    case popular = "/movie/popular"
    case topRated = "/movie/top_rated"
    case upcoming = "/movie/upcoming"
}

struct MovieListRequest: Request {
    typealias ReturnType = MovieResponseModel
    let movieListType: MovieListType
    let page: Int
    var path: String { return movieListType.rawValue }
    var queryParams: [String : Any]? {
        return ["page": page]
    }
}

extension APIClient {
    func getMovieList(type: MovieListType, page: Int) -> AnyPublisher<MovieResponseModel, NetworkRequestError> {
        let movieListRequest = MovieListRequest(movieListType: type, page: page)
        return request(movieListRequest)
    }
}
