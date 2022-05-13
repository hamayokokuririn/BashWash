//
//  ComplicationView.swift
//  BathWashForWatch WatchKit Extension
//
//  Created by 齋藤健悟 on 2022/05/13.
//

import SwiftUI
import ClockKit

struct ComplicationViewCircular: View {
  
  @State var text: String

  var body: some View {
    ZStack {
      Text(text)
    }
  }
}


struct ComplicationView_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            CLKComplicationTemplateGraphicCornerStackText(
                innerTextProvider: CLKSimpleTextProvider(text: "Should Wash"),
                outerTextProvider: CLKSimpleTextProvider(text: "Bath")
            ).previewContext()
        }
    }
}
