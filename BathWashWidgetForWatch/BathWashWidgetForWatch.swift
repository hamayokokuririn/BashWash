//
//  BathWashWidgetForWatch.swift
//  BathWashWidgetForWatch
//
//  Created by 齋藤健悟 on 2022/06/16.
//

import WidgetKit
import SwiftUI
import BathWashCore

struct BathWashWidgetForWatchEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        let _ = print(Self._printChanges())
        let _ = print(entry.date)
        ZStack {
            AccessoryWidgetBackground()
            Text("🛁")
                .font(.title.bold())
        }
        .widgetLabel {
            Text(entry.text)
        }
    }
}

@main
struct BathWashWidgetForWatch: Widget {
    let kind: String = "BathWashWidgetForWatch"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            BathWashWidgetForWatchEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct BathWashWidgetForWatch_Previews: PreviewProvider {
    static let entry = SimpleEntry(date: Date(),
                            text: WashDay.today.textForComplication)
    static var previews: some View {
        BathWashWidgetForWatchEntryView(entry: entry)
            .previewContext(WidgetPreviewContext(family: .accessoryCorner))
    }
}
