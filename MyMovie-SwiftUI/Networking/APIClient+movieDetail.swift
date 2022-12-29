//
//  APIClient+movieDetail.swift
//  MyMovie-SwiftUI
//
//  Created by Thy Nguyen on 12/27/22.
//  Copyright © 2022 Thy Nguyen. All rights reserved.
//

import Combine

struct MovieDetailRequest: Request {
    typealias ReturnType = MovieDetailModel
    let movieId: Int
    var path: String { return "/movie/\(movieId)" }
    var queryParams: [String: String]? {
        return ["append_to_response": "videos,recommendations"]
    }
}

extension APIClient {
    func getMovieDetail(movieId: Int) -> AnyPublisher<MovieDetailModel, NetworkRequestError> {
        let movieDetailRequest = MovieDetailRequest(movieId: movieId)
        return request(movieDetailRequest)
    }
}
