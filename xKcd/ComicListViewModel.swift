//
//  ComicListViewModel.swift
//  xKcd
//
//  Created by Daniil on 04.07.2020.
//  Copyright © 2020 kuluum. All rights reserved.
//

import Combine

final class ComicListViewModel: ObservableObject {
    
    @Published var comicList: [Comic] = []
    
    private let net = Network()
    private var cancelsDict: [UInt: AnyCancellable] = [:]
    
    func fakeComic() {
        let fcomic = Comic(num: 1, img: "asd")
        comicList.append(fcomic)
    }
    
    func realComic(id: UInt) {
        
        let cancelable = net.loadComic(id: id).sink(receiveCompletion: { (_) in
            print("")
        }) { (comic) in
            self.comicList.append(comic)
            self.cancelsDict.removeValue(forKey: id)
        }
        
        cancelsDict[id] = cancelable
    }
}
