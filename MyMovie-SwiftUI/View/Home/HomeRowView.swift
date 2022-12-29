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
    let rowViewModel: HomeRowViewModel
    var onLoadMore: (() -> Void)?
    
    @State private var scrollViewSize: CGSize = .zero
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10.0) {
            Text((rowViewModel.sectionType ?? .popular).description.uppercased())
                .font(.title)
                .fontWeight(.thin)
                .foregroundColor(Color.black.opacity(0.7))
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 10.0) {
                    ForEach(Array(dataSource.enumerated()), id: \.offset) { idx, itemModel in
                        NavigationLink(destination: NavigationLazyView(
                            HomeBuilder.makeMovieDetailView(withMovieId: itemModel.itemId ?? 0))) {
                            HomeItemView(itemViewModel: itemModel, type: rowViewModel.sectionType ?? .popular)
                        }
                    }
                }
                .background(
                    GeometryReader { geo -> Color in
                        scrollViewSize = geo.size
                        return .clear
                    }
                )
            }
            .frame(
                height: scrollViewSize.height
            )
        }
    }
    
    private var dataSource: [HomeItemViewModel] {
        rowViewModel.dataList.compactMap { $0 }
    }
}
