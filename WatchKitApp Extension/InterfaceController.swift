//
//  InterfaceController.swift
//  WatchKitApp Extension
//
//  Created by Openfield Mobility on 29/09/2016.
//  Copyright © 2016 Openfield Mobility. All rights reserved.
//

import WatchKit
import Foundation
import SkiKit

class InterfaceController: WKInterfaceController {
    
    @IBOutlet weak var mainTable: WKInterfaceTable!
    
    private var dataSource = SkiResortDataSource()
    
    override init() {
        super.init()
        
        reloadTableData()
    }

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func reloadTableData() {
        mainTable.setNumberOfRows(self.dataSource.count, withRowType: "SkiResortTableRow")
        for index in 0..<self.dataSource.count {
            let row = mainTable.rowControllerAtIndex(index) as! SkiResortTableRowController
            row.configureWithSkiResort(self.dataSource[index])
        }
    }
    
    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
        return self.dataSource[rowIndex]
    }
    
    override func handleActionWithIdentifier(identifier: String?, forRemoteNotification remoteNotification: [NSObject : AnyObject]) {
        if identifier == "stationButtonAction" {
            let stationInfo = remoteNotification["station"] as! Dictionary<String, AnyObject>
            let index = stationInfo["id"] as! Int
            let newTemperature = stationInfo["temperature_increase"] as! Int
            
            let SR = self.dataSource[index]
            print(SR.temperature)
            SR.temperature = SR.temperature + newTemperature
            print(SR.temperature)
            
            self.pushControllerWithName("DetailInterface", context: SR)
        }
    }
}
