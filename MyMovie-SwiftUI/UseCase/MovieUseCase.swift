//
//  MovieUseCase.swift
//  MyMovie-SwiftUI
//
//  Created by Thy Nguyen on 12/26/22.
//  Copyright © 2022 Thy Nguyen. All rights reserved.
//

import Combine

protocol MovieUseCaseInterface {
    func getMovieList(type: MovieListType, page: Int) -> AnyPublisher<MovieResponseModel, NetworkRequestError>
    func getMovieDetail(movieId: Int) -> AnyPublisher<MovieDetailModel, NetworkRequestError>
}

final class MovieUseCase: MovieUseCaseInterface {
    private let repository: Reposistory
    
    init(repository: Reposistory = Reposistory()) {
        self.repository = repository
    }
    
    func getMovieList(type: MovieListType, page: Int) -> AnyPublisher<MovieResponseModel, NetworkRequestError> {
        repository.getMovieList(type: type, page: page)
    }
    
    func getMovieDetail(movieId: Int) -> AnyPublisher<MovieDetailModel, NetworkRequestError> {
        repository.getMovieDetail(movieId: movieId)
    }
}
