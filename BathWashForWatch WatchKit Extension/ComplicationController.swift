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
                innerTextProvider: CLKSimpleTextProvider(text: washDay.textForComplication),
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
            CLKComplicationDescriptor(identifier: "BathWashComplication", displayName: "BathWashDay", supportedFamilies: [.graphicCorner])
        ]
        handler(descriptors)
    }
    
    // MARK: - Timeline Configuration
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        let futureDate = Calendar.current.date(byAdding: .day, value: 10, to: Date())
        handler(futureDate)
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
                date:  Date(),
                complicationTemplate: template)
            handler(entry)
        } else {
            handler(nil)
        }
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {

        let washInFuture = WashInFuture()
        let list = washInFuture.washList(after: date, limit: limit)
        let entries: [CLKComplicationTimelineEntry] = list.compactMap { wash in
            guard let template = makeTemplate(for: wash.washDay, complication: complication) else {
                return nil
            }
            let entry = CLKComplicationTimelineEntry(
                date: wash.date,
                complicationTemplate: template)
            return entry
        }
        handler(entries)
    }

    // MARK: - Sample Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        guard complication.family == .graphicCorner else {
            handler(nil)
            return
        }
        // This method will be called once per supported complication, and the results will be cached
        let template = CLKComplicationTemplateGraphicCornerStackText(
            innerTextProvider: CLKSimpleTextProvider(text: WashDay.today.textForComplication),
            outerTextProvider: CLKSimpleTextProvider(text: "Bath")
        )
        handler(template)
    }
}
