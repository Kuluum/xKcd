//
//  Network.swift
//  xKcd
//
//  Created by Daniil on 04.07.2020.
//  Copyright © 2020 kuluum. All rights reserved.
//

import Foundation
import Combine


protocol NetworkRepresentable {
    func urlBody() -> String
}

enum NetworkErrors: Error {
    case shit
}

struct Network: DataProvider {
    
    let host = "https://xkcd.com/"
    
    func fetch<D, M>(_ requestInfo: D) -> AnyPublisher<M, Error> where D : DataRequestInfo, M == D.Model {
        
        guard let url = URL(string:host + requestInfo.urlBody()) else {
            return Fail(error: NetworkErrors.shit).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: M.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
}
