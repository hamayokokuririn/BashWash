//
//  ViewController.swift
//  BathWashDay
//
//  Created by 齋藤健悟 on 2022/05/09.
//

import UIKit
import BathWashCore

class ViewController: UIViewController {

    @IBOutlet weak var washLabel: UILabel!
    @IBOutlet weak var lastWashDate: UILabel!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var today: UILabel!
    
    private let service = WashDayCheckService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateText()
        updateToday()
        navigationBar.delegate = self
        navigationBar.prefersLargeTitles = true
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(willEnterForeground),
                                               name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func willEnterForeground() {
        updateText()
    }
    
    func updateText() {
        let washDay = service.washDay()
        updateText(washDay: washDay.0, date: washDay.1)
    }
    
    func updateToday() {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .none
        f.locale = Locale(identifier: "ja_JP")
        let text = f.string(from: Date())
        today.text = "(\(text))"
    }

    func updateText(washDay: WashDay, date: Date?) {
        washLabel.text = washDay.text
        if let date = date {
            lastWashDate.text = dateToString(date: date)
        } else {
            lastWashDate.text = "--/--/--"
        }
    }
    
    func dateToString(date: Date) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date)
    }
    
    @IBAction func touchUpInside(_ sender: Any) {
        let alertController:UIAlertController =
        UIAlertController(title:"日付の更新",
                          message: nil,
                          preferredStyle: .actionSheet)
        
        let actionPositive = UIAlertAction(title: "今日、風呂洗った", style: .default){
            action in
            self.service.setStoredDateToday()
            self.updateText()
        }
        
        let actionNegative = UIAlertAction(title: "明日洗います", style: .default){
            action in
            // 日付は昨日で設定しておいて明日洗うことにする
            self.service.setStoredDateYesterday()
            self.updateText()
        }
        
        // actionを追加
        alertController.addAction(actionPositive)
        alertController.addAction(actionNegative)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        // UIAlertControllerの起動
        present(alertController, animated: true, completion: nil)
    }
    
}

extension ViewController: UINavigationBarDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        .topAttached
    }
}
