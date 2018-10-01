//
//  PrizesModel.swift
//  basketball
//
//  Created by Michael Vivar on 26/09/2018.
//  Copyright © 2018 Michael Vivar. All rights reserved.
//

import Foundation

struct Prizes: Codable {
    let first: Int
    let second: Int
    let third: Int
    let fourth: Int
    let reverse: Int
    
    init(firstQtr: Int, secondQtr: Int, thirdQtr: Int, fourthQtr: Int, reverse: Int) {
        self.first = firstQtr
        self.second = secondQtr
        self.third = thirdQtr
        self.fourth = fourthQtr
        self.reverse = reverse
    }
}
