//
//  BathWashWidget.swift
//  BathWashWidget
//
//  Created by 齋藤健悟 on 2022/06/16.
//

import WidgetKit
import SwiftUI
import BathWashCore

struct BathWashWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("\(entry.text) 🛁")
        }
    }
}

@main
struct BathWashWidget: Widget {
    let kind: String = "BathWashWidget"
    
    let families: [WidgetFamily] = {
        if #available(iOSApplicationExtension 16.0, *) {
            return [.systemSmall, .accessoryInline]
        } else {
            return [.systemSmall]
        }
    }()

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            BathWashWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies(families)
    }
    
}

struct BathWashWidget_Previews: PreviewProvider {
    static let entry = SimpleEntry(date: Date(),
                            text: WashDay.today.textForComplication)
    static var previews: some View {
        BathWashWidgetEntryView(entry: entry)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
