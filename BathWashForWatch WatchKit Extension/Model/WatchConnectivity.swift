//
//  WatchConnectivity.swift
//  BathWashForWatch WatchKit Extension
//
//  Created by 齋藤健悟 on 2022/05/11.
//

import Foundation
import WatchConnectivity
import Combine
import BathWashCore

final class WatchConnectivity: NSObject {

    private let session: WCSession
    let subject = PassthroughSubject<Date, Never>()
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
        session.activate()
    }
}

extension WatchConnectivity: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            // Error handring if need
            print(error.localizedDescription)
        } else {
            print("The session has completed activation.")
        }
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        guard let dateString = userInfo["dateString"] as? String,
              let date = try? JSONDecoder().decode(Date.self, from: dateString.data(using: .utf8)!) else {
            // Error handring if need
            return
        }
        self.subject.send(date)
    }
}
