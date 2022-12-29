//
//  NavigationLazyView.swift
//  MyMovie-SwiftUI
//
//  Created by Thy Nguyen on 12/29/22.
//  Copyright © 2022 Thy Nguyen. All rights reserved.
//

import SwiftUI

struct NavigationLazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}
