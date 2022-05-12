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
}

