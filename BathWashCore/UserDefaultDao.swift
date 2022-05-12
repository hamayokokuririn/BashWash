//
//  UserDefaultDao.swift
//  BathWashDay
//
//  Created by 齋藤健悟 on 2022/05/09.
//

import Foundation

public struct UserDefaultDao {
    let userDefault = UserDefaults.standard
    let key = "storedDate"
    
    public init() {}
    
    public var storedDate: Date? {
        get {
            if let date = userDefault.object(forKey: key) as? Date {
                return date
            }
            return nil
        }
        set (newValue) {
            guard let v = newValue else {
                return
            }
            userDefault.set(v, forKey: key)
        }
    }
}
