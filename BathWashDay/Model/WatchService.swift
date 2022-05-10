//
//  WatchService.swift
//  BathWashDay
//
//  Created by 齋藤健悟 on 2022/05/11.
//

import Foundation
import WatchConnectivity

final class WatchService: NSObject {
    
    var handler: (() -> Void)?
    
    static let shared = WatchService()
    private let session = WCSession.default
    
    override init() {
        super.init()
        session.delegate = self
        session.activate()
    }
    
    func transfer(dateString: String) {
        let userInfo = ["dateString": dateString]
        session.transferUserInfo(userInfo)
    }
}

extension WatchService: WCSessionDelegate {
    func sessionDidBecomeInactive(_ session: WCSession) {
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        } else {
            print("The session has completed activation.")
            handler?()
        }
    }
    
    func session(_ session: WCSession, didFinish userInfoTransfer: WCSessionUserInfoTransfer, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        } else {
            print("♥️\(userInfoTransfer.userInfo)")
        }
    }
    
}
