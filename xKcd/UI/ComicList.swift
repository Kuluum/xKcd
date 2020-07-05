//
//  ContentView.swift
//  xKcd
//
//  Created by Daniil on 04.07.2020.
//  Copyright © 2020 kuluum. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

struct ComicList: View {
    
    @ObservedObject private var viewModel: ComicListViewModel
    
    init(viewModel: ComicListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        GeometryReader { geometry in
            CollectionView(layout: self.layout(),
                           sections:[0] ,
                           items: self.viewModel.items,
                           prefetch: self.prefetch,
                           content: { (indexPath, item) in
                
                            ComicView(item: item).frame(width: UIScreen.main.bounds.width).eraseToAnyView()
                
            }).background(Color.white).frame(width:UIScreen.main.bounds.size.width, height:UIScreen.main.bounds.size.height).onAppear(perform: self.fetch)
        }
    }
    
    private func fetch() {
        viewModel.fetchComic(ids: [1,2,3,4,5,6])
    }

    func prefetch(_ indexPathes:[IndexPath]) {
        
        guard
            let row = indexPathes.first?.row,
            let comicList = viewModel.items[0]
        else { return }
        
        if row >= comicList.count - 3 {
            let toLoad = Array(comicList.count...comicList.count+5).map { UInt($0) }
            
            viewModel.fetchComic(ids: toLoad)
        }

    }
    
    func layout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }

}



#if DEBUG
struct ComicList_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello, World!")
    }
}
#endif