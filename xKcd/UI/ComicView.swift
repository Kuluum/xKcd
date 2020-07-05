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
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                AsyncImage(
                    url: URL(string: self.item.img)!,
                    placeholder: Text("Loading ..."),
                    configuration: { $0.resizable().frame(height: geometry.size.height).blur(radius: 9).eraseToAnyView() }
                )
                
                AsyncImage(
                    url: URL(string: self.item.img)!,
                    placeholder: Text("Loading ..."),
                    configuration: { $0.resizable().scaledToFit().eraseToAnyView() }
                )
            }
            
        }
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
