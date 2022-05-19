//
//  WashInFutureTests.swift
//  BathWashCoreTests
//
//  Created by 齋藤健悟 on 2022/05/19.
//

import XCTest
@testable import BathWashCore

class WashInFutureTests: XCTestCase {

    func testWashList() {
        let comp = DateComponents(month: 1, day: 1, hour: 0, minute: 0)
        let calendar = Calendar(identifier: .gregorian)
        let date = calendar.date(from: comp)!
        var mockDao = MockDao()
        mockDao.storedDate = date
        let service = WashDayCheckService(dao: mockDao)
        let washInF = WashInFuture(service: service)
        
        let result = washInF.washList(after: date, limit: 5)
        
        XCTAssertEqual(result.count, 6)
        
        let comp2 = DateComponents(month: 1, day: 2, hour: 0, minute: 0)
        let date2 = Calendar.current.date(from: comp2)!
        XCTAssertEqual(result[0].date, date2)
        XCTAssertEqual(result[0].washDay, .tomorrow)
        
        let comp3 = DateComponents(month: 1, day: 3, hour: 0, minute: 0)
        let date3 = Calendar.current.date(from: comp3)!
        XCTAssertEqual(result[1].date, date3)
        XCTAssertEqual(result[1].washDay, .today)
        
        let comp4 = DateComponents(month: 1, day: 7, hour: 0, minute: 0)
        let date4 = Calendar.current.date(from: comp4)!
        XCTAssertEqual(result[5].date, date4)
        XCTAssertEqual(result[5].washDay, .today)
    }

}

struct MockDao: StoreDateProtocol {
    var date: Date? = nil
    
    var storedDate: Date? {
        get {
            return date
        }
        set {
            self.date = newValue
        }
    }
}
