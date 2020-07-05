//
//  AsyncImage.swift
//  xKcd
//
//  Created by Daniil on 05.07.2020.
//  Copyright © 2020 kuluum. All rights reserved.
//

import SwiftUI
import Combine

struct AsyncImage<Placeholder: View>: View {
    @ObservedObject private var loader: ImageLoader
    private let placeholder: Placeholder?
    private let configuration: (Image) -> AnyView
    
    init(url: URL, placeholder: Placeholder? = nil, configuration: @escaping (Image) -> AnyView = { $0.eraseToAnyView() }) {
        loader = ImageLoader(url: url)
        self.placeholder = placeholder
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
            } else {
                placeholder
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
