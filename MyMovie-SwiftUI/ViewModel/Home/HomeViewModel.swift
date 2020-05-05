//
//  HomeViewModel.swift
//  MyMovie-SwiftUI
//
//  Created by Thy Nguyen on 5/1/20.
//  Copyright © 2020 Thy Nguyen. All rights reserved.
//

import Combine
import Foundation

class HomeViewModel: ObservableObject {
    @Published var popularMoviesRowViewModel: HomeRowViewModel?
    @Published var topRatedMoviesRowViewModel: HomeRowViewModel?
    @Published var upcomingMoviesRowViewModel: HomeRowViewModel?
    @Published var error: MovieError?
    private var disposables = Set<AnyCancellable>()
    
    func loadData() {
        getMovies(type: HomeSectionType.Popular, page: 1)
        getMovies(type: HomeSectionType.TopRated, page: 1)
        getMovies(type: HomeSectionType.Upcoming, page: 1)
    }
    
    func rowViewModel(from type: HomeSectionType) -> HomeRowViewModel? {
        switch type {
        case HomeSectionType.Popular:
            return popularMoviesRowViewModel
        case HomeSectionType.TopRated:
            return topRatedMoviesRowViewModel
        case HomeSectionType.Upcoming:
            return upcomingMoviesRowViewModel
        default:
            return nil
        }
    }
    
    private func getMovies(type: HomeSectionType, page: Int) {
        APIManager.shared.getMovies(type: type, page: page)
            .map {
                HomeRowViewModel(dataList: ($0.movies ?? []).map {
                    HomeItemViewModel(itemId: $0.movieId, title: $0.title, subTitle: nil, posterPath: $0.posterPath)
                }, sectionType: type, pagingInfo: $0.pagingInfo, isLoadingMore: false)
        }
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
            }, receiveValue: { [weak self] rowModel in
                guard let self = self else {
                    return
                }
                switch type {
                case HomeSectionType.Popular:
                    self.popularMoviesRowViewModel = rowModel
                case HomeSectionType.TopRated:
                    self.topRatedMoviesRowViewModel = rowModel
                case HomeSectionType.Upcoming:
                    self.upcomingMoviesRowViewModel = rowModel
                default:
                    break
                }
                
        })
            .store(in: &disposables)
    }
}
