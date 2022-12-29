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
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: MovieDetailViewModel
    
    private var coverImageSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 9 / 16)
    }
    
    private var posterImageSize: CGSize {
        return CGSize(width: 180.0 * 2 / 3, height: 180.0)
    }
    
    var body: some View {
        LoadingView(isShowing: $viewModel.isLoading) {
            ScrollView(.vertical, showsIndicators: false) {
                ZStack(alignment: .top) {
                    movieCover
                    middleview.padding(.top, coverImageSize.height - posterImageSize.height / 3)
                }.padding(.bottom, 20.0)
                movieContent
            }
            .edgesIgnoringSafeArea(.all)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .renderingMode(.template)
                    .foregroundColor(.white)
                    .imageScale(.large)
            })
            .onAppear {
                viewModel.trigger.send(())
            }
        }
    }
    
    private var middleview: some View {
        HStack(spacing: 16.0) {
            moviePoster
            VStack {
                Spacer()
                movieTitle
            }.padding(.bottom, 16.0)
            Spacer()
        }
    }
    
    private var movieCover: some View {
        if viewModel.coverImageUrl != nil {
            return AnyView(
                WebImage(url: viewModel.coverImageUrl!)
                    .resizable()
                    .placeholder {
                        Rectangle().foregroundColor(.gray)
                    }
                    .indicator(.activity)
                    .transition(.fade(duration: 0.5))
                    .frame(width: coverImageSize.width, height: coverImageSize.height, alignment: .center)
                    .scaledToFit()
            )
        } else {
            return AnyView(Color.gray.frame(width: coverImageSize.width, height: coverImageSize.height))
        }
    }
    
    private var moviePoster: some View {
        if viewModel.posterImageUrl != nil {
            return AnyView(
                WebImage(url: viewModel.posterImageUrl!)
                    .resizable()
                    .placeholder {
                        Rectangle().foregroundColor(.gray)
                    }
                    .indicator(.activity)
                    .transition(.fade(duration: 0.5))
                    .frame(width: posterImageSize.width, height: posterImageSize.height, alignment: .center)
                    .scaledToFit()
                    .cornerRadius(5.0)
                    .padding(.leading)
            )
        } else {
            return AnyView(Color.black
                            .opacity(0.8)
                            .frame(width: posterImageSize.width, height: posterImageSize.height)
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
                Text(viewModel.ratingText)
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
            }
            //Release date
            Text(viewModel.releaseDateText)
                .font(.caption)
                .fontWeight(.light)
                .foregroundColor(.gray)
        }
    }
    
    private var movieContent: some View {
        VStack(alignment: .leading, spacing: 10.0) {
            //Title
            Text(viewModel.movieDetailModel?.title ?? "")
                .font(.title)
                .fontWeight(.thin)
                .foregroundColor(Color.black.opacity(0.7))
            //Overview
            Text(viewModel.movieDetailModel?.overview ?? "")
                .font(.subheadline)
                .fontWeight(.light)
        }
        .padding(.leading)
        .padding(.trailing, 5.0)
    }
}
