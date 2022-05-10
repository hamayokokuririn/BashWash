//
//  ContentView.swift
//  BathWashForWatch WatchKit Extension
//
//  Created by 齋藤健悟 on 2022/05/10.
//

import SwiftUI

struct ContentView: View {
    @StateObject var connect = WatchConnectivity()
    
    var body: some View {
        Text(connect.dateString)
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
