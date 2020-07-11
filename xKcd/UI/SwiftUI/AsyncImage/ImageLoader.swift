//
//  ImageLoader.swift
//  xKcd
//
//  Created by Daniil on 05.07.2020.
//  Copyright © 2020 kuluum. All rights reserved.
//

import UIKit
import Combine

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    
    private(set) var isLoading = false
    
    private let url: URL
    private var cancellable: AnyCancellable?
    
    private static let imageProcessingQueue = DispatchQueue(label: "ImageLoader")
    
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
            .handleEvents(receiveCompletion: { [weak self] _ in self?.onFinish() },
                          receiveCancel: { [weak self] in self?.onFinish() })
            .subscribe(on: Self.imageProcessingQueue)
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
        isLoading = true
    }
    
    func cancel() {
        cancellable?.cancel()
    }
        
    private func onFinish() {
        isLoading = false
    }
    
}
