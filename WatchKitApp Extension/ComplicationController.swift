//
//  ComplicationController.swift
//  WatchKitApp Extension
//
//  Created by Openfield Mobility on 29/09/2016.
//  Copyright © 2016 Openfield Mobility. All rights reserved.
//

import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    
    private var skiResort: SkiResortDataSource!
    
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirectionsForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTimeTravelDirections) -> Void) {
        self.skiResort = SkiResortDataSource()
        handler(.Forward)
    }
    
    func getTimelineStartDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
        handler(NSDate())
    }
    
    func getTimelineEndDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
        handler(NSDate(timeIntervalSinceNow: (60 * 60 * 24)))
    }
    
    func getPrivacyBehaviorForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.ShowOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntryForComplication(complication: CLKComplication, withHandler handler: ((CLKComplicationTimelineEntry?) -> Void)) {
        // Call the handler with the current timeline entry
        
        if complication.family == .ModularLarge {
            let show = shows[0]
            let template = CLKComplicationTemplateModularLargeStandardBody()
            
            template.headerTextProvider = CLKTimeIntervalTextProvider(startDate: show.startDate, endDate: NSDate(timeInterval: show.length, sinceDate: show.startDate))
            template.body1TextProvider = CLKSimpleTextProvider(text: show.name, shortText: show.shortName)
            template.body2TextProvider = CLKSimpleTextProvider(text: show.genre)
            
            let entry = CLKComplicationTimelineEntry(date: NSDate(timeInterval: hour * -0.25, sinceDate: show.startDate), complicationTemplate: template)
            
            handler(entry)
        } else if complication.family == .ModularSmall {
            let station = skiResort[3]
            var fill: Float = (((100 * Float(station.temperature)) / 50) / 100) / 2
            
            if station.temperature > 0 {
                fill = fill + 0.5
            } else {
                fill = -0.5 - fill
                fill = -fill
            }
            
            let stringVersion = String(format: "%.2f", fill)
            print(stringVersion)
            
            let template = CLKComplicationTemplateModularSmallRingText()
            template.fillFraction = Float(stringVersion)! // Taux de remplissage de la barre de progression (entre 0 et 1)
            template.ringStyle = .Open // Si le cercle est fermé ou non
            template.textProvider = CLKSimpleTextProvider(text: "\(station.temperature)°") // Pas plus de 3 chiffres
            
            if station.temperature < -19 {
                template.textProvider = CLKSimpleTextProvider(text: "\(station.temperature)")
            }
            
            let entry = CLKComplicationTimelineEntry(date: NSDate(), complicationTemplate: template)
            
            handler(entry)
        }
    }
    
    func getTimelineEntriesForComplication(complication: CLKComplication, beforeDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
        // Call the handler with the timeline entries prior to the given date
        handler(nil)
    }
    
    func getTimelineEntriesForComplication(complication: CLKComplication, afterDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
        // Call the handler with the timeline entries after to the given date
        
        if complication.family == .ModularLarge {
            var entries: [CLKComplicationTimelineEntry] = []
            
            for show in shows {
                if entries.count < limit && show.startDate.timeIntervalSinceDate(date) > 0 {
                    let template = CLKComplicationTemplateModularLargeStandardBody()
                    
                    template.headerTextProvider = CLKTimeIntervalTextProvider(startDate: show.startDate, endDate: NSDate(timeInterval: show.length, sinceDate: show.startDate))
                    template.body1TextProvider = CLKSimpleTextProvider(text: show.name, shortText: show.shortName)
                    template.body2TextProvider = CLKSimpleTextProvider(text: show.genre)
                    
                    entries.append(CLKComplicationTimelineEntry(date: NSDate(timeInterval: hour * -0.25, sinceDate: show.startDate), complicationTemplate: template))
                }
            }
            
            handler(entries)
        } else if complication.family == .ModularSmall {
            handler(nil)
        }
    }
    
    // MARK: - Update Scheduling
    
    func getNextRequestedUpdateDateWithHandler(handler: (NSDate?) -> Void) {
        // Call the handler with the date when you would next like to be given the opportunity to update your complication content
        handler(nil);
    }
    
    // MARK: - Placeholder Templates
    
    func getPlaceholderTemplateForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        if complication.family == .ModularLarge {
            let template = CLKComplicationTemplateModularLargeStandardBody()
            
            template.headerTextProvider = CLKTimeIntervalTextProvider(startDate: NSDate(), endDate: NSDate(timeIntervalSinceNow: 60 * 60 * 1.5))
            template.body1TextProvider = CLKSimpleTextProvider(text: "Show Name", shortText: "Name")
            template.body2TextProvider = CLKSimpleTextProvider(text: "Show Genre", shortText: "Genre")
            
            handler(template)
        } else if complication.family == .ModularSmall {
            let template = CLKComplicationTemplateModularSmallRingText()
            template.fillFraction = 50.0
            template.ringStyle = CLKComplicationRingStyle(rawValue: 1)!
            template.textProvider = CLKSimpleTextProvider(text: "2")
            
            handler(template)
        }
    }
    
}





struct Show {
    var name: String
    var shortName: String?
    var genre: String
    
    var startDate:NSDate
    var length: NSTimeInterval
}

let hour: NSTimeInterval = 60 * 60
let shows = [
    Show(name: "Into the Wirld", shortName: "Into Wild", genre: "Documentary", startDate: NSDate(), length: hour * 1.5),
    Show(name: "24/7", shortName: nil, genre: "Drama", startDate: NSDate(timeIntervalSinceNow: hour * 1.5), length: hour),
    Show(name: "How to become rich", shortName: "Become Rich", genre: "Documentary", startDate: NSDate(timeIntervalSinceNow: hour * 2.5), length: hour * 3),
    Show(name: "NET Daily", shortName: nil, genre: "News", startDate: NSDate(timeIntervalSinceNow: hour * 5.5), length: hour)
]
        