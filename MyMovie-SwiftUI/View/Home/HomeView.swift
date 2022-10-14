//
//  HomeView.swift
//  MyMovie-SwiftUI
//
//  Created by Thy Nguyen on 4/30/20.
//  Copyright © 2020 Thy Nguyen. All rights reserved.
//

import SwiftUI
import Combine

struct HomeView: View {
    @EnvironmentObject var router: Router
    @ObservedObject var viewModel: HomeViewModel
    var sections: [HomeSectionType] = [
        .popular, .topRated, .upcoming
    ]
    
    var body: some View {
        NavigationStack(path: $router.path) {
            List {
                ForEach(sections) { section in
                    viewModel.rowViewModel(from: section).map { rowViewModel in
                        HomeRowView(rowViewModel: rowViewModel)
                    }
                    .listRowSeparator(.hidden)
                }
            }
            .listStyle(PlainListStyle())
            .navigationBarTitle("MY MOVIE", displayMode: .large)
            .navigationDestination(for: Int.self) { itemId in
                HomeBuilder.makeMovieDetailView(withMovieId: itemId)
            }
        }
        .onAppear {
            viewModel.loadData()
        }
    }
}
