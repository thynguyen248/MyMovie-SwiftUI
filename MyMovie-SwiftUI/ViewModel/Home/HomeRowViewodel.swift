//
//  HomeRowViewModel.swift
//  MyMovie-SwiftUI
//
//  Created by Thy Nguyen on 5/1/20.
//  Copyright © 2020 Thy Nguyen. All rights reserved.
//

import Combine

struct HomeRowViewModel {
    var dataList: [HomeItemViewModel]?
    var sectionType: HomeSectionType?
    var pagingInfo: PagingInfoModel?
    var isLoadingMore: Bool?
}
