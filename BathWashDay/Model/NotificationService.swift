//
//  NotificationService.swift
//  BathWashDay
//
//  Created by 齋藤健悟 on 2022/05/10.
//

import Foundation
import UserNotifications

class NotificationService: NSObject {
    
    static let shared = NotificationService()
    
    override init() {
        super.init()
        let center = UNUserNotificationCenter.current()
        center.delegate = self
    }
    
    func requestAuthorization() async throws -> Bool {
        let center = UNUserNotificationCenter.current()
        return try await center.requestAuthorization(options: [.badge, .sound, .alert])
    }
    
    func registerRepeat() {
        let content = UNMutableNotificationContent()
        content.title = "風呂掃除をチェック"
        content.sound = UNNotificationSound(named: UNNotificationSoundName("sound.mp3"))
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: DateComponents(hour: 17), repeats: true)
        let request = UNNotificationRequest(identifier: "today",
                                            content: content,
                                            trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
}

extension NotificationService: UNUserNotificationCenterDelegate {
    // フォアグラウンドで通知受信
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        return [.banner, .sound]
    }
}
