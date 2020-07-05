//
//  Comic.swift
//  xKcd
//
//  Created by Daniil on 04.07.2020.
//  Copyright © 2020 kuluum. All rights reserved.
//

import Foundation


struct Comic: Codable, Hashable, Identifiable {
    let id = UUID()
    
    let month: String
    let num: Int
    let link: String
    let year: String
    let news: String
    let safeTitle: String
    let transcript: String
    let alt: String
    let img: String
    let title: String
    let day: String
    
    init(num: Int) {
        self.num = num
        month = ""
        link = ""
        year = ""
        news = ""
        safeTitle = ""
        transcript = ""
        alt = ""
        img = ""
        title = ""
        day = ""

    }
    
    enum CodingKeys: String, CodingKey {
        case num, img
        case month, link, year, news
        case safeTitle = "safe_title"
        case transcript, alt, title, day
    }
}
