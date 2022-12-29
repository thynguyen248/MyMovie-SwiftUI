//
//  HomeItemView.swift
//  MyMovie-SwiftUI
//
//  Created by Thy Nguyen on 4/29/20.
//  Copyright © 2020 Thy Nguyen. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct HomeItemView: View {
    var itemViewModel: HomeItemViewModel
    var type: HomeSectionType
    
    var body: some View {
        VStack {
            if posterUrl != nil {
                WebImage(url: posterUrl!)
                    .resizable()
                    .placeholder {
                        Rectangle().foregroundColor(.gray)
                    }
                    .indicator(.activity)
                    .transition(.fade(duration: 0.5))
                    .frame(width: type.itemWidth, height: type.itemWidth * 3 / 2)
                    .scaledToFit()
                    .cornerRadius(8.0)
            } else {
                Color.gray.frame(width: type.itemWidth, height: type.itemWidth * 3 / 2)
                    .cornerRadius(8.0)
            }
            
            Text(itemViewModel.title ?? "")
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
                .foregroundColor(.primary)
                .font(.system(size: 16.0, weight: .light))
            Spacer()
        }
        .frame(width: type.itemWidth)
        .padding(.bottom, 10.0)
    }
    
    var posterUrl: URL? {
        return itemViewModel.posterPath?.posterUrl
    }
}










