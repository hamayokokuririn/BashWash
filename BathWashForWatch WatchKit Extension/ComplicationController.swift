//
//  ComplicationController.swift
//  BathWashForWatch WatchKit Extension
//
//  Created by 齋藤健悟 on 2022/05/10.
//

import ClockKit
import SwiftUI
import BathWashCore

extension ComplicationController {
    func makeTemplate(
        for washDay: WashDay,
        complication: CLKComplication
    ) -> CLKComplicationTemplate? {
        switch complication.family {
        case .graphicCorner:
            return CLKComplicationTemplateGraphicCornerStackText(
                innerTextProvider: CLKSimpleTextProvider(text: washDay.text),
                outerTextProvider: CLKSimpleTextProvider(text: "Bath")
            )
        default:
            return nil
        }
    }
}



class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Complication Configuration

    func getComplicationDescriptors(handler: @escaping ([CLKComplicationDescriptor]) -> Void) {
        let descriptors = [
            CLKComplicationDescriptor(identifier: "complication", displayName: "BathWashDay", supportedFamilies: CLKComplicationFamily.allCases)
            // Multiple complication support can be added here with more descriptors
        ]
        
        // Call the handler with the currently supported complication descriptors
        handler(descriptors)
    }
    
    func handleSharedComplicationDescriptors(_ complicationDescriptors: [CLKComplicationDescriptor]) {
        // Do any necessary work to support these newly shared complication descriptors
    }

    // MARK: - Timeline Configuration
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        // Call the handler with the last entry date you can currently provide or nil if you can't support future timelines
        handler(nil)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        // Call the handler with your desired behavior when the device is locked
        handler(.showOnLockScreen)
    }

    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Call the handler with the current timeline entry
        let service = WashDayCheckService.init()
        let washDay = service.washDay().0
        if let template = makeTemplate(for: washDay, complication: complication) {
          let entry = CLKComplicationTimelineEntry(
            date: Date() ,
            complicationTemplate: template)
          handler(entry)
        } else {
          handler(nil)
        }
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after the given date

        var entries: [CLKComplicationTimelineEntry] = []
        
        // リミットまで登録する
        for i in 0...limit {
            guard let addedDate = Calendar.current.date(byAdding: .day, value: i, to: date) else {
                break
            }
            let service = WashDayCheckService()
            let washDay = service.washDay(today: addedDate)
            if let nextWashDate = washDay.1,
                let template = makeTemplate(for: washDay.0, complication: complication) {
                let entry = CLKComplicationTimelineEntry(
                    date: nextWashDate,
                    complicationTemplate: template)
            entries.append(entry)
          }
        }
        handler(entries)
    }

    // MARK: - Sample Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        handler(nil)
    }
}
