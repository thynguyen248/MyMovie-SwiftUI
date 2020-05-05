//
//  HomeBuilder.swift
//  MyMovie-SwiftUI
//
//  Created by Thy Nguyen on 5/5/20.
//  Copyright © 2020 Thy Nguyen. All rights reserved.
//

import SwiftUI

class HomeBuilder {
    static func makeMovieDetailView(
        withMovieId movieId: Int
    ) -> some View {
        let detailViewModel = MovieDetailViewModel(movieId: movieId)
        let detailView = MovieDetailView(viewModel: detailViewModel)
        return detailView
    }
}
