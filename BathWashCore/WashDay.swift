//
//  WashDay.swift
//  BathWashDay
//
//  Created by 齋藤健悟 on 2022/05/09.
//

import Foundation

public enum WashDay {
    case undefined
    case today
    case tomorrow
    
    public var text: String {
        switch self {
        case .undefined:
            return "設定をしてください"
        case .today:
            return "風呂掃除をする日です"
        case .tomorrow:
            return "風呂掃除をしない日です"
        }
    }
    
    public var textForComplication: String {
        switch self {
        case .undefined:
            return "Unknown"
        case .today:
            return "Enjoy Washing"
        case .tomorrow:
            return "NO Washing"
        }
    }
}

public struct Wash {
    public let washDay: WashDay
    public let date: Date
}
