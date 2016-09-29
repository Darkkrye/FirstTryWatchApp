//
//  SkiResortTableRowController.swift
//  WatchKitComplicationTest
//
//  Created by Openfield Mobility on 29/09/2016.
//  Copyright © 2016 Openfield Mobility. All rights reserved.
//

import WatchKit


class SkiResortTableRowController: NSObject {
    
    @IBOutlet weak var titleLabel: WKInterfaceLabel!
    
    func configureWithSkiResort(skiResort: SkiResort) {
        self.titleLabel.setText(skiResort.name)
    }

}
