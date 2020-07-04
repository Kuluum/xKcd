//
//  Comic.swift
//  xKcd
//
//  Created by Daniil on 04.07.2020.
//  Copyright © 2020 kuluum. All rights reserved.
//

import Foundation

// MARK: - Comic
struct Comic: Codable, Hashable, Identifiable {
    var id = UUID()
    
//    let month: String
    let num: Int
//    let link, year, news, safeTitle: String
//    let transcript, alt: String
    let img: String
//    let title, day: String
    
    enum CodingKeys: String, CodingKey {
//        case month, num, link, year, news
//        case safeTitle = "safe_title"
//        case transcript, alt, img, title, day
        case num, img
    }
}
