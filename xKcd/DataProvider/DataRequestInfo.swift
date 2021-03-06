//
//  DataRequestInfo.swift
//  xKcd
//
//  Created by Daniil on 05.07.2020.
//  Copyright © 2020 kuluum. All rights reserved.
//

import Foundation

protocol DataRequestInfo: NetworkRepresentable {
    associatedtype Model: Codable
}

struct ComicByIdRequestInfo: DataRequestInfo  {
    typealias Model = Comic
    
    private let suffix = "/info.0.json"
    let id: String
    
    // MARK: - NetworkRepresentable
    
    func urlBody() -> String {
        return id + suffix
    }
}

struct LastComicRequestInfo: DataRequestInfo  {
    typealias Model = Comic
    
    private let suffix = "/info.0.json"
    
    // MARK: - NetworkRepresentable
    
    func urlBody() -> String {
        return suffix
    }
}
