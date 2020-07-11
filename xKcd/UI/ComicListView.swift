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

struct ComicListView: View {
    
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
        viewModel.fetchMoreComics()
    }

    func prefetch(_ indexPathes:[IndexPath]) {
        
        guard
            let row = indexPathes.first?.row,
            let comicList = viewModel.items[0]
        else { return }
        
        if row >= comicList.count - 3 {
            viewModel.fetchMoreComics()
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
