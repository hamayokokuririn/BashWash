//
//  WatchService.swift
//  BathWashDay
//
//  Created by 齋藤健悟 on 2022/05/11.
//

import Foundation
import WatchConnectivity
import Combine
import BathWashCore

final class WatchService: NSObject {
    
    let subject = PassthroughSubject<Void, Never>()
    private var cancellable: AnyCancellable?
    
    static let shared = WatchService()
    private let session = WCSession.default
    
    override init() {
        super.init()
        session.delegate = self
        session.activate()
    }
    
    func watchTransfer() {
        let dao = UserDefaultDao()
        if let date = dao.storedDate {
            cancellable = subject.sink {
                self.transfer(date: date)
            }
        }
    }
    
    private func transfer(date: Date) {
        if let encoded = try? JSONEncoder().encode(date) {
            let dateString = String(data: encoded, encoding: .utf8)!
            let userInfo = ["dateString": dateString]
            session.transferUserInfo(userInfo)
        }
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
            subject.send()
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
