//
//  WidgetProvider.swift
//  BathWashCore
//
//  Created by 齋藤健悟 on 2022/06/17.
//

import WidgetKit

@available(iOS 15.0, watchOS 9.0, *)
public struct Provider: TimelineProvider {
    public init() {}
    
    public func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), text: "placeholder")
    }

    public func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let service = WashDayCheckService.init()
        let washDay = service.washDay()
        let date = washDay.1 ?? Date()
        let entry = SimpleEntry(date: date, text: washDay.0.textForComplication)
        completion(entry)
    }

    public func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let washInFuture = WashInFuture()
        let list = washInFuture.washList(after: Date(), limit: 10)
        let entries: [SimpleEntry] = list.map { wash in
            let entry = SimpleEntry(date: wash.date, text: wash.washDay.textForComplication)
            return entry
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

public struct SimpleEntry: TimelineEntry {
    public init(date: Date, text: String) {
        self.date = date
        self.text = text
    }
    
    public let date: Date
    public let text: String
}
