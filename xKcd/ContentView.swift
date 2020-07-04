//
//  ContentView.swift
//  xKcd
//
//  Created by Daniil on 04.07.2020.
//  Copyright © 2020 kuluum. All rights reserved.
//

import SwiftUI
import Combine

struct ComicList: View {
    
    private var viewModel = ComicListViewModel()
    
    var body: some View {
        UIScrollViewWrapper {
            Comics().frame(height: 800)
            Comics().frame(height: 800)
            Comics().frame(height: 800)
            }.frame(height: 800).onAppear(perform: fetch)
    }
    
    private func fetch() {
        let net = Network()
        net.loadComic(id: 1) { (comic, error) in
            print(comic, error)
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ComicList()
    }
}

struct Comics: View {
    var body: some View {
        Text("Comics")
    }
}
