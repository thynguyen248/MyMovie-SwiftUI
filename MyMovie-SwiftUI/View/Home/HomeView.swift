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
    @ObservedObject var viewModel: HomeViewModel
    var sections: [HomeSectionType] = [
        .Popular, .TopRated, .Upcoming
    ]
    
    var body: some View {
        NavigationView {
            List(self.sections) { section in
                self.viewModel.rowViewModel(from: section).map { rowViewModel in
                    HomeRowView(rowViewModel: rowViewModel)
                }
            }
            .navigationBarTitle("MY MOVIE")
        }
        .onAppear {
            self.viewModel.loadData()
        }
    }
}
