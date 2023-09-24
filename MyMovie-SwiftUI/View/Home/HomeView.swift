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
    @StateObject var viewModel: HomeViewModel
    
    var body: some View {
        LoadingView(isShowing: $viewModel.isLoading) {
            NavigationView {
                List {
                    ForEach(viewModel.dataSource) { rowViewModel in
                        HomeRowView(rowViewModel: rowViewModel)
                    }
                }
                .listStyle(PlainListStyle())
                .navigationBarTitle("MY MOVIE", displayMode: .large)
            }
            .onAppear {
                viewModel.trigger.send(())
            }
        }
    }
}
