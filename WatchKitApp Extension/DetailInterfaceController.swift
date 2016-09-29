//
//  DetailInterfaceController.swift
//  WatchKitComplicationTest
//
//  Created by Openfield Mobility on 29/09/2016.
//  Copyright © 2016 Openfield Mobility. All rights reserved.
//

import WatchKit
import Foundation


class DetailInterfaceController: WKInterfaceController {
    
    @IBOutlet weak var nameLabel: WKInterfaceLabel!
    @IBOutlet weak var temperatureLabel: WKInterfaceLabel!
    @IBOutlet weak var photoImageView: WKInterfaceImage!
    @IBOutlet weak var dateLabel: WKInterfaceDate!
    
    private var photoDownloadManager: PhotoDownloadManager?
    private var skiResort: SkiResort?

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        if let skiResort = context as? SkiResort {
            self.skiResort = skiResort
            
            // Une fois le contexte défini, on peut configurer les InterfaceObject de notre vue
            self.nameLabel.setText(skiResort.name)
            self.temperatureLabel.setText("\(String(skiResort.temperature))°C")
            self.photoDownloadManager = PhotoDownloadManager(photoURL: skiResort.photoURL)
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        if let skiResort = self.skiResort {
            self.photoDownloadManager?.retrievePhoto({ (image) -> () in
                self.photoImageView.setImage(image)
            })
            
            setTitle(skiResort.name)
        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
