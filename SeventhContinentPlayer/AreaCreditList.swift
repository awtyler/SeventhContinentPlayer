//
//  AreaCreditList.swift
//  SeventhContinentPlayer
//
//  Created by Aaron Tyler on 2/4/19.
//  Copyright © 2019 Aaron Tyler. All rights reserved.
//

import Foundation
class AreaCreditList {
    
    let trackNumber: Int
    let areaName: String
    let creditList: [Credit]
    
    init(trackNumber: Int, areaName: String, creditList: [Credit]) {
        self.trackNumber = trackNumber
        self.areaName = areaName
        self.creditList = creditList
    }
    
}
