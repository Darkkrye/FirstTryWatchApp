//
//  SkiResortDataSource.swift
//  WatchKitComplicationTest
//
//  Created by Openfield Mobility on 29/09/2016.
//  Copyright © 2016 Openfield Mobility. All rights reserved.
//

import UIKit

class SkiResortDataSource: NSObject {
    var allObjects: Array<SkiResort>!
    
    override internal init() {
        self.allObjects = [
            SkiResort(name: "Arcabulle", photoURL: NSURL(string: "http://www.trinum.com/ibox/ftpcam/les-arcs_arcabulle.jpg")!, temperature: 5),
            SkiResort(name: "Arcs 1600 Pistes", photoURL: NSURL(string: "http://static1.lesarcsnet.com/image_uploader/webcam/large/lesarcs-1600-cam.jpg")!, temperature: -5),
            SkiResort(name: "Vanoise Express", photoURL: NSURL(string: "http://trinum.com/ibox/ftpcam/Peisey-Vallandry_vanoise-expresse.jpg")!, temperature: 25),
            SkiResort(name: "Arc 1950 Village", photoURL: NSURL(string: "https://noahcatalog1.blob.core.windows.net/img/15ead594-3847-441c-9aa7-802af71d94d1.jpg")!, temperature: -20)
        ]
    }
    
    internal var count: Int {
        get {
            return self.allObjects.count
        }
    }
    
    internal subscript(index: Int) -> SkiResort {
        return self.allObjects[index]
    }
}
