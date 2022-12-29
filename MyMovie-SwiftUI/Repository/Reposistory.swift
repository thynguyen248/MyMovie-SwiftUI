//
//  Reposistory.swift
//  MyMovie-SwiftUI
//
//  Created by Thy Nguyen on 12/26/22.
//  Copyright © 2022 Thy Nguyen. All rights reserved.
//

import Combine

protocol ReposistoryInterface {
    func getMovieList(type: MovieListType, page: Int) -> AnyPublisher<MovieResponseModel, NetworkRequestError>
    func getMovieDetail(movieId: Int) -> AnyPublisher<MovieDetailModel, NetworkRequestError>
}

final class Reposistory: ReposistoryInterface {
    private let apiClient: APIClient
    
    init(apiClient: APIClient = APIClient()) {
        self.apiClient = apiClient
    }
    
    func getMovieList(type: MovieListType, page: Int) -> AnyPublisher<MovieResponseModel, NetworkRequestError> {
        return apiClient.getMovieList(type: type, page: page)
    }
    
    func getMovieDetail(movieId: Int) -> AnyPublisher<MovieDetailModel, NetworkRequestError> {
        return apiClient.getMovieDetail(movieId: movieId)
    }
}
