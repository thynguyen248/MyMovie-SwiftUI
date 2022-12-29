//
//  HomeViewModel.swift
//  MyMovie-SwiftUI
//
//  Created by Thy Nguyen on 5/1/20.
//  Copyright © 2020 Thy Nguyen. All rights reserved.
//

import Combine
import Foundation

final class HomeViewModel: ObservableObject {
    @Published var dataSource: [HomeRowViewModel] = []
    @Published var error: NetworkRequestError?
    @Published var isLoading = false
    
    let trigger = PassthroughSubject<Void, Never>()
    let loadingMoreSection = CurrentValueSubject<HomeSectionType?, Never>(nil)
    private var disposables = Set<AnyCancellable>()
    
    private let movieUseCase: MovieUseCase
    
    init(movieUseCase: MovieUseCase = MovieUseCase()) {
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
            .flatMap { [weak self] _ in
                return Publishers.Zip3(
                    self?.getMovieList(sectionType: .popular) ?? Empty().eraseToAnyPublisher(),
                    self?.getMovieList(sectionType: .topRated) ?? Empty().eraseToAnyPublisher(),
                    self?.getMovieList(sectionType: .upcoming) ?? Empty().eraseToAnyPublisher()
                )
            }
            .map({ (popular, toprated, upcoming) in
                return [popular, toprated, upcoming]
            })
            .assign(to: &$dataSource)
        
        loadingMoreSection
            .drop(while: { $0 == nil })
            .handleEvents(receiveSubscription: { [weak self] _ in
                guard let sectionType = self?.loadingMoreSection.value,
                      let targetIdx = self?.dataSource.firstIndex(where: { $0.sectionType == sectionType })
                else { return }
                self?.dataSource[targetIdx].isLoadingMore = true
            })
            .flatMap { [weak self] sectionType -> AnyPublisher<HomeRowViewModel, Never> in
                guard let sectionType = sectionType,
                      let currentPage = self?.dataSource.first(where: { $0.sectionType == sectionType })?.pagingInfo?.currentPage
                else { return Empty().eraseToAnyPublisher() }
                return self?.getMovieList(sectionType: sectionType, page: currentPage + 1) ?? Empty().eraseToAnyPublisher()
            }
            .sink(receiveValue: { [weak self] row in
                guard let sectionType = self?.loadingMoreSection.value,
                      let targetIdx = self?.dataSource.firstIndex(where: { $0.sectionType == sectionType })
                else { return }
                self?.dataSource[targetIdx] = row
            })
            .store(in: &disposables)
    }
    
    private func getMovieList(sectionType: HomeSectionType, page: Int = 1) -> AnyPublisher<HomeRowViewModel, Never> {
        return movieUseCase.getMovieList(type: sectionType.movieListType, page: page)
            .asResult()
            .receive(on: DispatchQueue.main)
            .map({ [weak self] result -> HomeRowViewModel in
                switch result {
                case .success(let responseModel):
                    let availableItemVMs = self?.dataSource.first(where: { $0.sectionType == sectionType })?.dataList ?? []
                    let movies = responseModel.movies ?? []
                    let itemVMs = availableItemVMs + movies.map { HomeItemViewModel(itemId: $0.movieId, title: $0.title, subTitle: nil, posterPath: $0.posterPath) }
                    let rowVM = HomeRowViewModel(dataList: itemVMs, sectionType: sectionType, pagingInfo: responseModel.pagingInfo)
                    return rowVM
                case .failure(let error):
                    self?.error = error
                    return HomeRowViewModel(dataList: [], sectionType: nil, pagingInfo: nil, isLoadingMore: false)
                }
            })
            .eraseToAnyPublisher()
    }
}
