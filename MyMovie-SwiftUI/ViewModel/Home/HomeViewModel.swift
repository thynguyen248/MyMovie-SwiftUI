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
        getMovies(type: HomeSectionType.Popular)
        getMovies(type: HomeSectionType.TopRated)
        getMovies(type: HomeSectionType.Upcoming)
    }
    
    func loadMore(type: HomeSectionType) {
        getMovies(type: type)
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
    
    private func getMovies(type: HomeSectionType, page: Int? = nil) {
        let targetPagingInfo = rowViewModel(from: type)?.pagingInfo
        let targetPage = (page ?? targetPagingInfo?.currentPage ?? 0) + 1
        APIManager.shared.getMovies(type: type, page: targetPage)
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
                }, receiveValue: { [weak self] response in
                    guard let self = self else {
                        return
                    }
                    
                    let availableItemVMs = self.rowViewModel(from: type)?.dataList ?? []
                    let movies = response.movies ?? []
                    let itemVMs = availableItemVMs + movies.map { HomeItemViewModel(itemId: $0.movieId, title: $0.title, subTitle: nil, posterPath: $0.posterPath) }
                    let rowVM = HomeRowViewModel(dataList: itemVMs, sectionType: type, pagingInfo: response.pagingInfo, isLoadingMore: false)
                    
                    switch type {
                    case HomeSectionType.Popular:
                        self.popularMoviesRowViewModel = rowVM
                    case HomeSectionType.TopRated:
                        self.topRatedMoviesRowViewModel = rowVM
                    case HomeSectionType.Upcoming:
                        self.upcomingMoviesRowViewModel = rowVM
                    default:
                        break
                    }
                    
            })
            .store(in: &disposables)
    }
}
