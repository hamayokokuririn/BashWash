//
//  BathWashDayTests.swift
//  BathWashDayTests
//
//  Created by 齋藤健悟 on 2022/05/09.
//

import XCTest
@testable import BathWashCore

class BathWashDayTests: XCTestCase {

    func testDateIntervalSinceToday() {
        let s = WashDayCheckService()
        let comp = DateComponents(month: 1, day: 2, hour: 0, minute: 0)
        let date = Calendar.current.date(from: comp)!
        var result = s.dateIntervalSinceToday(date, today: date)
        XCTAssertEqual(result, 0)
        
        var modifiedDate = Calendar.current.date(byAdding: .day, value: -1, to: date)!
        result = s.dateIntervalSinceToday(modifiedDate, today: date)
        XCTAssertEqual(result, 1)
        
        modifiedDate = Calendar.current.date(byAdding: .hour, value: -1, to: date)!
        result = s.dateIntervalSinceToday(modifiedDate, today: date)
        // １時間だけでも前日だから一日経過したことになる
        XCTAssertEqual(result, 1)
    }

    func testShouldWash() {
        let s = WashDayCheckService()
        var result = s.shouldWash(dateInterval: 0)
        XCTAssertFalse(result)
        
        result = s.shouldWash(dateInterval: -1)
        XCTAssertFalse(result)
        
        result = s.shouldWash(dateInterval: 1)
        XCTAssertFalse(result)
        
        result = s.shouldWash(dateInterval: 2)
        XCTAssertTrue(result)
        
        result = s.shouldWash(dateInterval: 3)
        XCTAssertFalse(result)
        
        result = s.shouldWash(dateInterval: 4)
        XCTAssertTrue(result)
    }
    
}
