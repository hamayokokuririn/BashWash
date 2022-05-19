//
//  WashDayCheckService.swift
//  BashWashCore
//
//  Created by 齋藤健悟 on 2022/05/12.
//

import Foundation

public struct WashDayCheckService {
    private var dao: StoreDateProtocol
    
    public init(dao: StoreDateProtocol = UserDefaultDao()) {
        self.dao = dao
    }
    
    public func check(_ date: Date, today: Date = Date()) -> Bool {
        let interval = dateInterval(date, since: today)
        return shouldWash(dateInterval: interval)
    }
    
    func shouldWash(dateInterval: Int) -> Bool {
        if dateInterval < 1 {
            // 0,1日は掃除しない
            return false
        }
        // 2日ごとに掃除する
        return dateInterval.isMultiple(of: 2)
    }
    
    func dateInterval(_ date: Date, since target: Date = Date()) -> Int {
        // 日付の数字だけで比較する24時間経過していなくても日付が変更していれば変更とみなす
        let resetDate = resetTime(date: date)
        let resetToday = resetTime(date: target)
        
        let interval = resetToday.timeIntervalSince(resetDate)
        let ret = interval / 86400

        return Int(floor(ret))
    }
    
    // 時間、分、秒の情報を落とす
    func resetTime(date: Date) -> Date {
        let calendar: Calendar = Calendar(identifier: .gregorian)
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)

        components.hour = 0
        components.minute = 0
        components.second = 0

        return calendar.date(from: components)!
    }
    
    public func washDay(today: Date = Date()) -> (WashDay, Date?){
        guard let date = dao.storedDate else {
            return (washDay: .undefined, date: nil)
        }
        let shouldWash = check(date, today: today)
        if shouldWash {
            return (washDay: .today, date: date)
            
        } else {
            return (washDay: .tomorrow, date: date)
        }
    }
    
    public mutating func setStoredDateToday() {
        dao.storedDate = Date()
    }
    
    public mutating func setStoredDateYesterday() {
        dao.storedDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())
    }
}
