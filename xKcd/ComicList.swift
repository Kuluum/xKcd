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
    @State private var comicsSubscriber: AnyCancellable?
    
    @State var items: [Int: [Comic]] = [0:[]]
//    @State var counter = 0
    
    init() {
        let viewModel = ComicListViewModel()
        self.viewModel = viewModel

        
    }
    
    var body: some View {
        GeometryReader { geometry in
            CollectionView(layout: self.generateLayout(), sections:[0] , items: self.items, prefetch: self.prefetch, content: { (indexPath, item) in
                AnyView(
                    VStack {
                        Text(String(item.num))
                        AsyncImage(
                            url: URL(string: item.img)!,
                            placeholder: Text("Loading ..."),
                            configuration: { $0.resizable() }
                        )
                    }.frame(width: geometry.size.width)
                )
            }).frame(width:geometry.size.width, height:geometry.size.height).onAppear(perform: self.fetch)
        }
    }
    
    private func fetch() {
        comicsSubscriber = viewModel.$comicList.sink(receiveValue: { (comic) in
            self.items[0] = self.viewModel.comicList
//            print(comic)
        })
        
        viewModel.realComic(id: 1)
        viewModel.realComic(id: 2)
        viewModel.realComic(id: 3)
        viewModel.realComic(id: 4)
        viewModel.realComic(id: 5)
        
    }

    func prefetch(_ indexPathes:[IndexPath]) {
        
        let row = indexPathes.first!.row
        
        if row >= viewModel.comicList.count - 3 {
            for i in viewModel.comicList.count...viewModel.comicList.count+5 {
                let contains = viewModel.comicList.contains { comic in
                    comic.num == i
                }
                
                if !contains {
                    print("loading", i)
                    viewModel.realComic(id: UInt(i))
                }
            }
        }

    }
    
    func generateLayout() -> UICollectionViewLayout {
    
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

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ComicList()
//    }
//}

//
//class ImageLoader: ObservableObject {
//
//    var downloadedImage: UIImage?
//    let didChange = PassthroughSubject<ImageLoader?, Never>()
//
//    func load(url: String) {
//
//        guard let imageURL = URL(string: url) else {
//            fatalError("ImageURL is not correct!")
//        }
//
//        URLSession.shared.dataTask(with: imageURL) { data, response, error in
//
//            guard let data = data, error == nil else {
//                DispatchQueue.main.async {
//                     self.didChange.send(nil)
//                }
//                return
//            }
//
//            self.downloadedImage = UIImage(data: data)
//            DispatchQueue.main.async {
//                self.didChange.send(self)
//            }
//
//        }.resume()
//
//    }
//
//
//}
//
//
//struct URLImage: View {
//
//    @ObservedObject private var imageLoader = ImageLoader()
//
//    var placeholder: Image
//
//    init(url: String, placeholder: Image = Image(systemName: "photo")) {
//        self.placeholder = placeholder
//        self.imageLoader.load(url: url)
//    }
//
//    var body: some View {
//        if let uiImage = self.imageLoader.downloadedImage {
//            return Image(uiImage: uiImage)
//        } else {
//            return placeholder
//        }
//    }
//
//}
//


class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    
    private(set) var isLoading = false
    
    private let url: URL
    private var cancellable: AnyCancellable?
    
    private static let imageProcessingQueue = DispatchQueue(label: "image-processing")
    
    init(url: URL) {
        self.url = url
    }
    
    deinit {
        cancellable?.cancel()
    }
    
    func load() {
        guard !isLoading else { return }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .handleEvents(receiveSubscription: { [weak self] _ in self?.onStart() },
                          receiveCompletion: { [weak self] _ in self?.onFinish() },
                          receiveCancel: { [weak self] in self?.onFinish() })
            .subscribe(on: Self.imageProcessingQueue)
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
    }
    
    func cancel() {
        cancellable?.cancel()
    }
    
    private func onStart() {
        isLoading = true
    }
    
    private func onFinish() {
        isLoading = false
    }
    
}


struct AsyncImage<Placeholder: View>: View {
    @ObservedObject private var loader: ImageLoader
    private let placeholder: Placeholder?
    private let configuration: (Image) -> Image
    
    init(url: URL, placeholder: Placeholder? = nil, configuration: @escaping (Image) -> Image = { $0 }) {
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
                Image(uiImage: loader.image!).resizable().aspectRatio(contentMode: .fit)
            } else {
                placeholder
            }
        }
    }
}

