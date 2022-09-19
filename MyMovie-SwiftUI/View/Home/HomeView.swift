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
        .popular, .topRated, .upcoming
    ]
    
    var body: some View {
        NavigationView {
          List {
              ForEach(sections) { section in
                viewModel.rowViewModel(from: section).map { rowViewModel in
                  HomeRowView(rowViewModel: rowViewModel)
                }
              }
            }
          .listStyle(PlainListStyle())
          .navigationBarTitle("MY MOVIE", displayMode: .large)
        }
        .onAppear {
          viewModel.loadData()
        }
    }
}
