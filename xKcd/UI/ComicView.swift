//
//  ComicView.swift
//  xKcd
//
//  Created by Daniil on 05.07.2020.
//  Copyright © 2020 kuluum. All rights reserved.
//

import SwiftUI

struct ComicView: View {
    
    let item: Comic
    private let loader: ImageLoader
    
    
    @State private var scale: CGFloat = 1.0
    @State private var imgSize: CGSize = .zero
    @State private var fitInScreen = false
    
    init(item: Comic) {
        self.item = item
        self.loader = ImageLoader(url: URL(string:item.img)!)
    }
    
    var body: some View {
        GeometryReader { geometry in
            
                ZStack {
                    // Blurry background
                    AsyncImage(
                        loader: self.loader,
                        configuration: { $0.resizable().blur(radius: 9).eraseToAnyView() }
                    ).frame(height: geometry.size.height)
                    
                    // Image with double tap x2 sizing
                    ScrollView([.horizontal, .vertical]) {
                        AsyncImage(
                            loader: self.loader,
                            configuration: { $0.resizable().scaledToFit()
                                .eraseToAnyView() }
                        )
                            .offset(
                                x: self.scale > 1 && self.imgSize.width > geometry.size.width / 2 ? self.imgSize.width - geometry.size.width / 2 : 0,
                                y: self.scale > 1 && self.imgSize.height > geometry.size.height / 2 ? self.imgSize.height - geometry.size.height / 2 : 0)
                            .background(GeometryReader {
                                Color.clear.preference(key: ViewSizeKey.self, value: $0.frame(in: .local).size)
                            })
                            .frame(maxWidth: self.scale * geometry.size.width, maxHeight: self.scale * geometry.size.height)
                            .frame(minWidth: self.scale * self.imgSize.width, minHeight: self.scale * self.imgSize.height)
                        
                            
                    }
                    .frame(width:geometry.size.width, height:geometry.size.height)
                    .onPreferenceChange(ViewSizeKey.self) {
                        if self.imgSize == .zero {
                            self.imgSize = CGSize(width: $0.width, height: $0.height)
                        }
                        self.fitInScreen = ($0.width <= geometry.size.width) && ($0.height <= geometry.size.height)
                    }
                    .disabled(self.fitInScreen)
                    
                }
        }.gesture(
            TapGesture(count: 2).onEnded({
                self.scale = self.scale == 1 ? 2 : 1
        }))
    }

}

struct ViewSizeKey: PreferenceKey {
    static var defaultValue: CGSize { CGSize.zero }
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = CGSize(width:value.width + nextValue().width, height: value.height + nextValue().height)
    }
}

#if DEBUG
struct ComicView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Text("da")
            AsyncImage_Previews.previews
        }
    }
}
#endif
