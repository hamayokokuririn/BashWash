//
//  ViewModel.swift
//  BathWashForWatch WatchKit Extension
//
//  Created by 齋藤健悟 on 2022/05/12.
//

import Foundation
import Combine
import BathWashCore
import ClockKit

final class ViewModel: ObservableObject {

    @Published var text: String = "--"
    
    private let watchConnectivity = WatchConnectivity()
    private var cancellable: AnyCancellable?
    
    init() {
        cancellable = watchConnectivity.subject
            .receive(on: DispatchQueue.main)
            .sink { date in
                var dao = UserDefaultDao()
                dao.storedDate = date
                self.update()
            }
        update()
    }
    
    private func update() {
        let service = WashDayCheckService()
        let day = service.washDay().0
        self.text = day.text
        
        let server = CLKComplicationServer.sharedInstance()
        if let comps = server.activeComplications,
           let bathComp = comps.first(where: { comp in
               comp.identifier == "BathWashComplication"
           }) {
            server.reloadTimeline(for: bathComp)
        }
        
    }
}

extension CLKComplicationServer {
    
    // Safely access the server's active complications.
    @MainActor
    func getActiveComplications() async -> [CLKComplication] {
        return await withCheckedContinuation { continuation in
            
            // First, set up the notification.
            let center = NotificationCenter.default
            let mainQueue = OperationQueue.main
            var token: NSObjectProtocol?
            token = center.addObserver(forName: .CLKComplicationServerActiveComplicationsDidChange, object: nil, queue: mainQueue) { _ in
                center.removeObserver(token!)
                continuation.resume(returning: self.activeComplications!)
            }
            
            // Then check to see if we have a valid active complications array.
            if activeComplications != nil {
                center.removeObserver(token!)
                continuation.resume(returning: self.activeComplications!)
            }
        }
    }
}

