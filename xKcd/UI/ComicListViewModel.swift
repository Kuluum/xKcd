//
//  ComicListViewModel.swift
//  xKcd
//
//  Created by Daniil on 04.07.2020.
//  Copyright © 2020 kuluum. All rights reserved.
//

import Combine
import Foundation

final class ComicListViewModel: ObservableObject {
    
    private let dataProvider: DataProvider
    
    
    @Published var items: [Int : [Comic]] = [0:[]]
    
    private var comicList: [Comic] = []
    private var cancelsDict: [UInt: AnyCancellable] = [:]
    private var loadedComicIdSet: Set<UInt> = []
    
    init(dataProvider: DataProvider) {
        self.dataProvider = dataProvider
    }
    
    func fetchComic(id: UInt) {
        
        if loadedComicIdSet.contains(id) {
            return
        }
        
        let comicRequestInfo = ComicRequestInfo(id: String(id))
        
        let cancelable = dataProvider.fetch(comicRequestInfo).receive(on: DispatchQueue.main).sink(receiveCompletion: { _ in })
        { (comic) in
            self.comicList.append(comic)
            self.loadedComicIdSet.insert(id)
            self.cancelsDict.removeValue(forKey: id)
            self.items[0] = self.comicList
        }
        
        cancelsDict[id] = cancelable
    }
    
    func fetchComic(ids: [UInt]) {
        ids.forEach { fetchComic(id: $0) }
    }
}
