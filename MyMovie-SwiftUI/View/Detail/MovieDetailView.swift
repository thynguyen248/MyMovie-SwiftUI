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
    let leftMargin: CGFloat = 16.0
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                ZStack {
                    VStack {
                        //Cover image
                        if self.viewModel.coverImageUrl != nil {
                            AnimatedImage(url: self.viewModel.coverImageUrl!)
                                .resizable()
                                .placeholder {
                                    Rectangle().foregroundColor(.gray)
                                        .frame(width: geometry.size.width, height: geometry.size.width * 2 / 3)
                            }
                                .indicator(.activity) // Activity Indicator
                                .animation(.easeInOut(duration: 0.5)) // Animation Duration
                                .transition(.fade)
                                .frame(width: geometry.size.width, height: geometry.size.width * 2 / 3)
                                .scaledToFit()
                        } else {
                            Color.gray.frame(width: geometry.size.width, height: geometry.size.width * 2 / 3)
                        }
                        Spacer()
                    }
                    
                    //Poster + Rating + Release date
                    HStack {
                        //Poster
                        if self.viewModel.posterImageUrl != nil {
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
                                .padding(.leading, self.leftMargin)
                        } else {
                            Color.black
                                .opacity(0.8)
                                .frame(width: self.posterImageWidth, height: self.posterImageHeight)
                                .cornerRadius(5.0)
                                .padding(.leading, self.leftMargin)
                        }
                        
                        VStack {
                            Spacer()
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
                        Spacer()
                    }
                    .padding(.top, (geometry.size.width * 2 / 3) - self.posterImageHeight / 2)
                }
                .padding(.bottom, 20.0)
                
                //Title + overview
                VStack(alignment: .leading, spacing: 10.0) {
                    Text(self.viewModel.movieDetailModel?.title ?? "")
                        .font(.title)
                        .fontWeight(.thin)
                        .foregroundColor(Color.black.opacity(0.7))
                    Text(self.viewModel.movieDetailModel?.overview ?? "")
                        .font(.subheadline)
                        .fontWeight(.light)
                }
                .padding(.leading, self.leftMargin)
                .padding(.trailing, 5.0)
            }
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                self.viewModel.loadData()
            }
        }
    }
}
