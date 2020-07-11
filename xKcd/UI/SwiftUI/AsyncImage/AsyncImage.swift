//
//  AsyncImage.swift
//  xKcd
//
//  Created by Daniil on 05.07.2020.
//  Copyright © 2020 kuluum. All rights reserved.
//

import SwiftUI
import Combine

struct AsyncImage: View {
    @ObservedObject private var loader: ImageLoader
    
    private let configuration: (Image) -> AnyView
    
    init(url: URL, configuration: @escaping (Image) -> AnyView = { $0.eraseToAnyView() }) {
        loader = ImageLoader(url: url)
        self.configuration = configuration
    }
    
    init(loader: ImageLoader, configuration: @escaping (Image) -> AnyView = { $0.eraseToAnyView() }) {
        self.loader = loader
        self.configuration = configuration
    }
    
    var body: some View {
        image
            .onAppear(perform: loader.load)
            .onDisappear(perform: loader.cancel)
    }
    
    private var image: some View {
        Group {
            if loader.image != nil {
                configuration(Image(uiImage: loader.image!))
            }
        }
    }
}

#if DEBUG
struct AsyncImage_Previews: PreviewProvider {
    static var previews: some View {
        Image(uiImage: UIImage(named: "photo")!)
    }
}
#endif
