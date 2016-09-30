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
        handler([.Forward, .Backward])
    }
    
    func getTimelineStartDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
        handler(NSDate(timeIntervalSinceNow: -6 * HOUR))
    }
    
    func getTimelineEndDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
        handler(NSDate(timeIntervalSinceNow: 12 * HOUR))
    }
    
    func getPrivacyBehaviorForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.ShowOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntryForComplication(complication: CLKComplication, withHandler handler: ((CLKComplicationTimelineEntry?) -> Void)) {
        // Call the handler with the current timeline entry
        
        if complication.family == .ModularLarge {
            /*let template = CLKComplicationTemplateModularLargeStandardBody()
            var entry = CLKComplicationTimelineEntry()
            
            for show in shows {
                if show.startDate.isEqualToDate(show.startDate) {
                    template.headerTextProvider = CLKTimeIntervalTextProvider(startDate: show.startDate, endDate: NSDate(timeInterval: show.length, sinceDate: show.startDate))
                    template.body1TextProvider = CLKSimpleTextProvider(text: show.name, shortText: show.shortName)
                    template.body2TextProvider = CLKSimpleTextProvider(text: show.genre)
                    
                    entry = CLKComplicationTimelineEntry(date: NSDate(timeInterval: hour, sinceDate: show.startDate), complicationTemplate: template)
                    break
                }
            }
            
            handler(entry)*/
            
            for movie in movies {
                //---display the movie that is currently playing or the next one
                // that is coming up---
                if (abs(movie.runningDate.timeIntervalSinceNow) < movie.runningTime) {
                    let modularLargeTemplate = CLKComplicationTemplateModularLargeStandardBody()
                    modularLargeTemplate.headerTextProvider = CLKTimeIntervalTextProvider(startDate: movie.runningDate, endDate: NSDate(timeInterval: movie.runningTime, sinceDate: movie.runningDate))
                    modularLargeTemplate.body1TextProvider = CLKSimpleTextProvider(text: movie.movieName, shortText: movie.movieName)
                    modularLargeTemplate.body2TextProvider = CLKSimpleTextProvider(text: "\(movie.runningTime / MINUTE) mins", shortText: nil)
                    
                    let entry = CLKComplicationTimelineEntry(date:NSDate(), complicationTemplate: modularLargeTemplate)
                    handler(entry)
                }
            }
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
        
        if complication.family == .ModularLarge {
            var timelineEntries: [CLKComplicationTimelineEntry] = []
            
            for movie in movies {
                if timelineEntries.count < limit && movie.runningDate.timeIntervalSinceDate(date) < 0 {
                    let modularLargeTemplate = CLKComplicationTemplateModularLargeStandardBody()
                    modularLargeTemplate.headerTextProvider = CLKTimeIntervalTextProvider( startDate: movie.runningDate, endDate: NSDate(timeInterval: movie.runningTime, sinceDate: movie.runningDate))
                    modularLargeTemplate.body1TextProvider = CLKSimpleTextProvider(text: movie.movieName, shortText: movie.movieName)
                    modularLargeTemplate.body2TextProvider = CLKSimpleTextProvider(text: "\(movie.runningTime / MINUTE) mins", shortText: nil)
                    
                    let entry = CLKComplicationTimelineEntry(date:NSDate(timeInterval: 0 * MINUTE, sinceDate: movie.runningDate), complicationTemplate: modularLargeTemplate)
                    timelineEntries.append(entry)
                }
            }
            
            handler(timelineEntries)
        } else {
            handler(nil)
        }
    }
    
    func getTimelineEntriesForComplication(complication: CLKComplication, afterDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
        // Call the handler with the timeline entries after to the given date
        
        if complication.family == .ModularLarge {
            /*var entries: [CLKComplicationTimelineEntry] = []
            
            for show in shows {
                if entries.count < limit && show.startDate.timeIntervalSinceDate(date) > 0 {
                    
                    let template = CLKComplicationTemplateModularLargeStandardBody()
                    
                    template.headerTextProvider = CLKTimeIntervalTextProvider(startDate: show.startDate, endDate: NSDate(timeInterval: show.length, sinceDate: show.startDate))
                    template.body1TextProvider = CLKSimpleTextProvider(text: show.name, shortText: show.shortName)
                    template.body2TextProvider = CLKSimpleTextProvider(text: show.genre)

                    entries.append(CLKComplicationTimelineEntry(date: NSDate(timeInterval: hour * -0.001, sinceDate: show.startDate), complicationTemplate: template))
                }
            }
            
            handler(entries)*/
            
            
            var timelineEntries: [CLKComplicationTimelineEntry] = []
            
            for movie in movies {
                if timelineEntries.count < limit && movie.runningDate.timeIntervalSinceDate(date) > 0 {
                    let modularLargeTemplate = CLKComplicationTemplateModularLargeStandardBody()
                    modularLargeTemplate.headerTextProvider = CLKTimeIntervalTextProvider(startDate: movie.runningDate, endDate: NSDate(timeInterval: movie.runningTime, sinceDate: movie.runningDate))
                    modularLargeTemplate.body1TextProvider = CLKSimpleTextProvider(text: movie.movieName, shortText: movie.movieName)
                    modularLargeTemplate.body2TextProvider = CLKSimpleTextProvider(text: "\(movie.runningTime / MINUTE) mins", shortText: nil)
                    
                    let entry = CLKComplicationTimelineEntry(date:NSDate( timeInterval: 0 * MINUTE, sinceDate: movie.runningDate), complicationTemplate: modularLargeTemplate)
                    timelineEntries.append(entry)
                }
            }
            
            handler(timelineEntries)
        } else if complication.family == .ModularSmall {
            handler(nil)
        }
    }
    
    // MARK: - Update Scheduling
    
    func getNextRequestedUpdateDateWithHandler(handler: (NSDate?) -> Void) {
        // Call the handler with the date when you would next like to be given the opportunity to update your complication content
        handler(NSDate(timeIntervalSinceNow: MINUTE))
    }
    
    // MARK: - Placeholder Templates
    
    func getPlaceholderTemplateForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        if complication.family == .ModularLarge {
            /*let template = CLKComplicationTemplateModularLargeStandardBody()
            
            template.headerTextProvider = CLKTimeIntervalTextProvider(startDate: NSDate(), endDate: NSDate(timeIntervalSinceNow: 60 * 60 * 1.5))
            template.body1TextProvider = CLKSimpleTextProvider(text: "Show Name", shortText: "Name")
            template.body2TextProvider = CLKSimpleTextProvider(text: "Show Genre", shortText: "Genre")
            
            handler(template)*/
            
            
            let modularLargeTemplate = CLKComplicationTemplateModularLargeStandardBody()
            modularLargeTemplate.headerTextProvider = CLKTimeIntervalTextProvider(startDate: NSDate(), endDate: NSDate(timeIntervalSinceNow: 1.5 * HOUR))
            modularLargeTemplate.body1TextProvider = CLKSimpleTextProvider(text: "Movie Name", shortText: "Movie")
            modularLargeTemplate.body2TextProvider = CLKSimpleTextProvider(text: "Running Time", shortText: "Time")
            
            handler(modularLargeTemplate)
        } else if complication.family == .ModularSmall {
            let template = CLKComplicationTemplateModularSmallRingText()
            template.fillFraction = 50.0
            template.ringStyle = CLKComplicationRingStyle(rawValue: 1)!
            template.textProvider = CLKSimpleTextProvider(text: "2")
            
            handler(template)
        }
    }
}

struct Movie {
    var movieName: String
    var runningTime: NSTimeInterval  // in seconds
    var runningDate: NSDate
    var rating:Float                 // 1 to 10
}

let HOUR: NSTimeInterval = 60 * 60
let MINUTE: NSTimeInterval = 60

let movies = [
    Movie(movieName: "Terminator 2: Judgement Day",
        runningTime: 137 * MINUTE,
        runningDate: NSDate(timeIntervalSinceNow: -257 * MINUTE),
        rating:8),
    Movie(movieName: "World War Z ",
        runningTime: 116 * MINUTE,
        runningDate: NSDate(timeIntervalSinceNow: -120 * MINUTE),
        rating:7),
    Movie(movieName: "Secondhand Lions",
        runningTime: 90 * MINUTE,
        runningDate: NSDate(timeIntervalSinceNow: 10 * MINUTE),
        rating:8),
    Movie(movieName: "The Dark Knight ",
        runningTime: 152 * MINUTE,
        runningDate: NSDate(timeIntervalSinceNow: 100 * MINUTE),
        rating:9),
    Movie(movieName: "The Prestige",
        runningTime: 130 * MINUTE,
        runningDate: NSDate(timeIntervalSinceNow: 252 * MINUTE),
        rating:8),
]





/*struct Show {
    var id: Int
    var name: String
    var shortName: String?
    var genre: String
    
    var startDate:NSDate
    var length: NSTimeInterval
}

let hour: NSTimeInterval = 60 * 60
let shows = [
    Show(id: 0, name: "Into the Wild", shortName: "Into Wild", genre: "Documentary", startDate: NSDate(), length: 60 * 2), // 0h00 -> 1h00
    Show(id: 1, name: "24/7", shortName: nil, genre: "Drama", startDate: NSDate(timeIntervalSinceNow: 60 * 2), length: hour), // 1h00 -> 2h00
    Show(id: 2, name: "How to become rich", shortName: "Become Rich", genre: "Documentary", startDate: NSDate(timeIntervalSinceNow: hour * 2), length: hour), // 2h00 -> 3h00
    Show(id: 3, name: "NET Daily", shortName: nil, genre: "News", startDate: NSDate(timeIntervalSinceNow: hour * 3), length: hour) // 3h00 -> 4h00
]*/