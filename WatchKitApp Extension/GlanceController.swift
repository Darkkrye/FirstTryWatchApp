//
//  GlanceController.swift
//  WatchKitComplicationTest
//
//  Created by Openfield Mobility on 29/09/2016.
//  Copyright © 2016 Openfield Mobility. All rights reserved.
//

import WatchKit
import Foundation


class GlanceController: WKInterfaceController {
    
    @IBOutlet weak var temperatureLabel: WKInterfaceLabel!
    @IBOutlet weak var titleLabel: WKInterfaceLabel!
    @IBOutlet weak var dateLabel: WKInterfaceDate!
    @IBOutlet weak var timeLabel: WKInterfaceDate!
    @IBOutlet weak var image: WKInterfaceImage!
    
    private var dataSource: SkiResortDataSource
    private var photoDownloadManager: PhotoDownloadManager?
    
    override init() {
        self.dataSource = SkiResortDataSource()
    }

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        let index = Int(arc4random_uniform(UInt32(self.dataSource.count)))
        let skiResort = self.dataSource[index]
        
        self.titleLabel.setText(skiResort.name)
        self.temperatureLabel.setText("\(skiResort.temperature)°C")
        self.photoDownloadManager = PhotoDownloadManager(photoURL: skiResort.photoURL)
        
        self.photoDownloadManager?.retrievePhoto({ (image) -> () in
            self.image.setImage(image)
        })
        
        setTitle(skiResort.name)
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
