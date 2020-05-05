//
//  HomeItemViewModel.swift
//  MyMovie-SwiftUI
//
//  Created by Thy Nguyen on 5/1/20.
//  Copyright © 2020 Thy Nguyen. All rights reserved.
//

import Foundation

struct HomeItemViewModel: Identifiable {
    let itemId: Int?
    let title: String?
    let subTitle: String?
    let posterPath: String?
    
    var id: Int {
        return itemId ?? 0
    }
}
