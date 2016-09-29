//
//  SkiResort.swift
//  WatchKitComplicationTest
//
//  Created by Openfield Mobility on 29/09/2016.
//  Copyright © 2016 Openfield Mobility. All rights reserved.
//

import UIKit

class SkiResort: NSObject {
    internal var name: String!
    internal var photoURL: NSURL!
    internal var temperature: Int!
    
    override init() {
        self.name = nil
        self.photoURL = nil
        self.temperature = nil
    }
    
    init(name: String, photoURL: NSURL, temperature: Int) {
        self.name = name
        self.photoURL = photoURL
        self.temperature = temperature
    }
}
