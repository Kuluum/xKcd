//
//  DataProvider.swift
//  xKcd
//
//  Created by Daniil on 05.07.2020.
//  Copyright © 2020 kuluum. All rights reserved.
//

import Combine

protocol DataProvider {   
    func fetch<D, M>(_ requestInfo: D) -> AnyPublisher<M, Error> where D : DataRequestInfo, M == D.Model
}
