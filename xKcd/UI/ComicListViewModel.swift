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
    
    private var lastLoadedNum: UInt = 0
    
    init(dataProvider: DataProvider) {
        self.dataProvider = dataProvider
    }
    
    func fetchMoreComics() {
        if comicList.count == 0 {
            fetchLastComic()
            return
        }
        
        let moreIds = Array((lastLoadedNum-5..<lastLoadedNum).reversed())
        fetchComic(ids: moreIds)
        lastLoadedNum -= 5
    }
    
    private func fetchLastComic() {
        let lastComicCancellFakeId: UInt = 999999
        
        let lastComic = LastComicRequestInfo()
        let canclelable = dataProvider.fetch(lastComic).sink(receiveCompletion: {_ in }) { (comic) in
            self.lastLoadedNum = UInt(comic.num)
            self.comicList.append(comic)
            self.cancelsDict.removeValue(forKey: lastComicCancellFakeId)
            
            // After fetching the last comic we know it's id and can fetch futher.
            self.fetchMoreComics()
        }
        
        cancelsDict[lastComicCancellFakeId] = canclelable
    }
    
    private func fetchComic(ids: [UInt]) {
        ids.forEach { fetchComic(id: $0) }
    }
    
    private func fetchComic(id: UInt) {
        let comicRequestInfo = ComicByIdRequestInfo(id: String(id))
        
        let cancelable = dataProvider.fetch(comicRequestInfo).receive(on: DispatchQueue.main).sink(receiveCompletion: { _ in })
        { (comic) in
            self.comicList.append(comic)
            self.cancelsDict.removeValue(forKey: id)
            self.items[0] = self.comicList
        }
        
        cancelsDict[id] = cancelable
        
    }
}
