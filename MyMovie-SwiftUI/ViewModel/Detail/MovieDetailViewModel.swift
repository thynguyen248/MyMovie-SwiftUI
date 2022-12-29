//
//  MovieDetailViewModel.swift
//  MyMovie-SwiftUI
//
//  Created by Thy Nguyen on 5/4/20.
//  Copyright © 2020 Thy Nguyen. All rights reserved.
//

import Combine
import Foundation

final class MovieDetailViewModel : ObservableObject {
    @Published var movieDetailModel: MovieDetailModel?
    @Published var isLoading = false
    @Published var error: NetworkRequestError?
    
    private let movieId: Int
    private let movieUseCase: MovieUseCase
    
    let trigger = PassthroughSubject<Void, Never>()
    private var disposables = Set<AnyCancellable>()
    
    init(movieId: Int, movieUseCase: MovieUseCase = MovieUseCase()) {
        self.movieId = movieId
        self.movieUseCase = movieUseCase
        binding()
    }
    
    func binding() {
        trigger
            .handleEvents(receiveSubscription: { [weak self] _ in
                self?.isLoading = true
            }, receiveOutput: { [weak self] _ in
                self?.isLoading = false
            })
            .flatMap { [movieUseCase, movieId] _ in
                return movieUseCase.getMovieDetail(movieId: movieId)
                    .asResult()
                    .receive(on: DispatchQueue.main)
                    .map({ [weak self] result -> MovieDetailModel? in
                        switch result {
                        case .success(let movieDetail):
                            return movieDetail
                        case .failure(let error):
                            self?.error = error
                            return nil
                        }
                    })
            }
            .assign(to: &$movieDetailModel)
    }
    
    var posterImageUrl: URL? {
        return movieDetailModel?.posterPath?.posterUrl
    }
    var coverImageUrl: URL? {
        return movieDetailModel?.videos?.results?.first?.key?.videoThumbnailUrl ?? movieDetailModel?.backDropPath?.posterUrl
    }
    var ratingText: String {
        return String(format: "%.1f", (movieDetailModel?.rating ?? 0.0))
    }
    var releaseDateText: String {
        return movieDetailModel?.releaseDate?.getShortDateFormat() ?? ""
    }
}
