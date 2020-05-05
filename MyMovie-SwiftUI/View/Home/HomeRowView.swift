//
//  HomeRowView.swift
//  MyMovie-SwiftUI
//
//  Created by Thy Nguyen on 5/5/20.
//  Copyright © 2020 Thy Nguyen. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct HomeRowView: View {
    var rowViewModel: HomeRowViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10.0) {
            Text((self.rowViewModel.sectionType ?? HomeSectionType.Popular).description.uppercased())
                .font(.title)
                .fontWeight(.thin)
                .foregroundColor(Color.black.opacity(0.7))
            
            rowViewModel.dataList.map { itemList in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .top, spacing: 10.0) {
                        ForEach(itemList) { itemModel in
                            NavigationLink(destination: HomeBuilder.makeMovieDetailView(withMovieId: itemModel.itemId ?? 0)) {
                                HomeItemView(itemViewModel: itemModel, type: self.rowViewModel.sectionType ?? HomeSectionType.Popular)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func movieDetailView(movieId: Int) -> MovieDetailView {
        let detailViewModel = MovieDetailViewModel(movieId: movieId)
        let detailView = MovieDetailView(viewModel: detailViewModel)
        return detailView
    }
}
