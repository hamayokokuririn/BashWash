//
//  WatchConnectivity.swift
//  BathWashForWatch WatchKit Extension
//
//  Created by 齋藤健悟 on 2022/05/11.
//

import Foundation

import WatchConnectivity

final class WatchConnectivity: NSObject, ObservableObject {

    @Published var dateString: String = "--"
    
    private let session: WCSession
    
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
        guard let data = userInfo["dateString"] as? String else {
            // Error handring if need
            return
        }
        self.dateString = data
        print("♥️ \(data)")
    }
}
