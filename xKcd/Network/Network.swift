//
//  Network.swift
//  xKcd
//
//  Created by Daniil on 04.07.2020.
//  Copyright © 2020 kuluum. All rights reserved.
//

import Foundation
import Combine

struct Network {
    let host = "https://xkcd.com/"
    
//    func loadComic(id: UInt, result:@escaping ((Comic?, Error?)->())) {
//        let idStr = String(id)
//
//        let requestUrlString = host + idStr + "/info.0.json"
//
//        guard let url = URL(string: requestUrlString) else {
//            result(nil, nil)
//            return
//        }
//
//        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
//            if let data  = data {
//                let comic = try? JSONDecoder().decode(Comic.self, from: data)
//                result(comic, error)
//                return
//            }
//            result(nil, error)
//        }
//        task.resume()
//
//    }
    
    func loadComic(id: UInt) -> AnyPublisher<Comic, Error> {
        let idStr = String(id)
        
        let requestUrlString = host + idStr + "/info.0.json"
        
        let url = URL(string: requestUrlString)
        
//        guard let url = URL(string: requestUrlString) else {
//            return Fail(error: Error())
//        }
        
        return URLSession.shared.dataTaskPublisher(for: url!)
            .map { $0.data }
            .decode(type: Comic.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
