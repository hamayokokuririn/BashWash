//
//  ViewModel.swift
//  BathWashForWatch WatchKit Extension
//
//  Created by 齋藤健悟 on 2022/05/12.
//

import Foundation
import Combine
import BathWashCore

final class ViewModel: ObservableObject {

    @Published var text: String = "--"
    
    private let watchConnectivity = WatchConnectivity()
    private var cancellable: AnyCancellable?
    
    init() {
        cancellable = watchConnectivity.subject.sink { date in
            var dao = UserDefaultDao()
            dao.storedDate = date
            self.update()
        }
        update()
    }
    
    private func update() {
        let service = WashDayCheckService()
        let day = service.washDay().0
        self.text = day.text
    }
}
