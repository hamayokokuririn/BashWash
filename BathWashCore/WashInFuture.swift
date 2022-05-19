//
//  WashInFuture.swift
//  BathWashCore
//
//  Created by 齋藤健悟 on 2022/05/19.
//

import Foundation

public struct WashInFuture {
    private let service: WashDayCheckService
    
    public init(service: WashDayCheckService = WashDayCheckService()) {
        self.service = service
    }
    
    public func washList(after date: Date, limit: Int) -> [Wash] {
        let calendar = Calendar(identifier: .gregorian)
        let resetedDate = service.resetTime(date: date)
        var list = [Wash]()
        for i in 0...limit {
            guard let nextDate = calendar.date(byAdding: .day, value: 1, to: resetedDate),
                  let addedDate = calendar.date(byAdding: .day, value: i, to: nextDate) else {
                break
            }
            let washDay = service.washDay(today: addedDate)
            list.append(Wash(washDay: washDay.0, date: addedDate))
        }
        return list
    }
}
