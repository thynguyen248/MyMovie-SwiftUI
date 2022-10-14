//
//  ContentView.swift
//  MyMovie-SwiftUI
//
//  Created by Thy Nguyen on 4/29/20.
//  Copyright © 2020 Thy Nguyen. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @StateObject var router = Router()
    
    var body: some View {
        HomeView(viewModel: HomeViewModel())
            .environmentObject(router)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
