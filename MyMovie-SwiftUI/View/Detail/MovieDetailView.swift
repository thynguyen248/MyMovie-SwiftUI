//
//  MovieDetailView.swift
//  MyMovie-SwiftUI
//
//  Created by Thy Nguyen on 5/4/20.
//  Copyright © 2020 Thy Nguyen. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct MovieDetailView: View {
    @ObservedObject var viewModel: MovieDetailViewModel
    
    let posterImageHeight: CGFloat = 180.0
    var posterImageWidth: CGFloat {
        return posterImageHeight * 2 / 3
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                ZStack(alignment: .top) {
                    self.movieCover(size: CGSize(width: geometry.size.width, height: geometry.size.width * 2 / 3))
                    self.middleview.padding(.top, (geometry.size.width * 2 / 3) - self.posterImageHeight / 2)
                }.padding(.bottom, 20.0)
                self.movieContent
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            self.viewModel.loadData()
        }
    }
    
    private var middleview: some View {
        HStack {
            moviePoster
            VStack {
                Spacer()
                movieTitle
            }
            Spacer()
        }
    }
    
    private func movieCover(size: CGSize) -> some View {
        if self.viewModel.coverImageUrl != nil {
            return AnyView(
                AnimatedImage(url: self.viewModel.coverImageUrl!)
                    .resizable()
                    .placeholder {
                        Rectangle().foregroundColor(.gray)
                            .frame(width: size.width, height: size.height)
                }
                    .indicator(.activity) // Activity Indicator
                    .animation(.easeInOut(duration: 0.5)) // Animation Duration
                    .transition(.fade)
                    .frame(width: size.width, height: size.height)
                    .scaledToFit()
            )
        } else {
            return AnyView(Color.gray.frame(width: size.width, height: size.height))
        }
    }
    
    private var moviePoster: some View {
        if self.viewModel.posterImageUrl != nil {
            return AnyView(
                AnimatedImage(url: self.viewModel.posterImageUrl!)
                    .resizable()
                    .placeholder {
                        Rectangle().foregroundColor(.gray)
                }
                    .indicator(.activity) // Activity Indicator
                    .animation(.easeInOut(duration: 0.5)) // Animation Duration
                    .transition(.fade)
                    .frame(width: self.posterImageWidth, height: self.posterImageHeight)
                    .cornerRadius(5.0)
                    .scaledToFit()
                    .padding(.leading)
            )
        } else {
            return AnyView(Color.black
                .opacity(0.8)
                .frame(width: self.posterImageWidth, height: self.posterImageHeight)
                .cornerRadius(5.0)
                .padding(.leading)
            )
        }
    }
    
    private var movieTitle: some View {
        VStack(alignment: .leading, spacing: 5.0) {
            //Rating
            HStack {
                Text("Rating")
                    .font(.title)
                    .fontWeight(.thin)
                Text(self.viewModel.ratingText)
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
            }
            //Release date
            Text(self.viewModel.releaseDateText)
                .font(.caption)
                .fontWeight(.light)
                .foregroundColor(.gray)
        }
    }
    
    private var movieContent: some View {
        VStack(alignment: .leading, spacing: 10.0) {
            //Title
            Text(self.viewModel.movieDetailModel?.title ?? "")
                .font(.title)
                .fontWeight(.thin)
                .foregroundColor(Color.black.opacity(0.7))
            //Overview
            Text(self.viewModel.movieDetailModel?.overview ?? "")
                .font(.subheadline)
                .fontWeight(.light)
        }
        .padding(.leading)
        .padding(.trailing, 5.0)
    }
}
