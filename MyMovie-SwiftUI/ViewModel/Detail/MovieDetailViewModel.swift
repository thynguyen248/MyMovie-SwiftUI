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
    @Published var error: MovieError?
    
    let movieId: Int
    
    private var disposables = Set<AnyCancellable>()
    
    init(movieId: Int) {
        self.movieId = movieId
        loadData()
    }
    
    func loadData() {
        APIManager.shared.getMovieDetail(movieId: movieId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] value in
                guard let self = self else {
                    return
                }
                switch value {
                case .failure(let error):
                    self.error = error
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] detailModel in
                guard let self = self else {
                    return
                }
                self.movieDetailModel = detailModel
            })
        .store(in: &disposables)
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
