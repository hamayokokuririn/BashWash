//
//  WashDay.swift
//  BathWashDay
//
//  Created by 齋藤健悟 on 2022/05/09.
//

import Foundation

enum WashDay {
    case undefined
    case today
    case tomorrow
    
    var text: String {
        switch self {
        case .undefined:
            return "設定をしてください"
        case .today:
            return "風呂掃除をする日です"
        case .tomorrow:
            return "風呂掃除をしない日です"
        }
    }
}

struct WashDayCheckService {
    
    
    func check(_ date: Date) -> Bool {
        let interval = dateIntervalSinceToday(date)
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
    
    func dateIntervalSinceToday(_ date: Date, today: Date = Date()) -> Int {
        // 日付の数字だけで比較する24時間経過していなくても日付が変更していれば変更とみなす
        let resetDate = resetTime(date: date)
        let resetToday = resetTime(date: today)
        
        let interval = resetToday.timeIntervalSince(resetDate)
        let ret = interval / 86400

        return Int(floor(ret))
    }
    
    // 時間、分、秒の情報を落とす
    private func resetTime(date: Date) -> Date {
        let calendar: Calendar = Calendar(identifier: .gregorian)
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)

        components.hour = 0
        components.minute = 0
        components.second = 0

        return calendar.date(from: components)!
    }
    
}
