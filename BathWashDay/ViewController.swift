//
//  ViewController.swift
//  BathWashDay
//
//  Created by 齋藤健悟 on 2022/05/09.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var washLabel: UILabel!
    @IBOutlet weak var lastWashDate: UILabel!
    
    
    var dao = UserDefaultDao()
    let service = WashDayCheckService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkDate()
    }
    
    func checkDate() {
        guard let date = dao.storedDate else {
            updateText(washDay: .undefined, date: nil)
            return
        }
        let shouldWash = service.check(date)
        if shouldWash {
            updateText(washDay: .today, date: date)
            
        } else {
            updateText(washDay: .tomorrow, date: date)
        }
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
            self.dao.storedDate = Date()
            self.checkDate()
        }
        
        let actionNegative = UIAlertAction(title: "明日洗います", style: .default){
            action in
            // 日付は昨日で設定しておいて明日洗うことにする
            self.dao.storedDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())
            self.checkDate()
        }
        
        // actionを追加
        alertController.addAction(actionPositive)
        alertController.addAction(actionNegative)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        // UIAlertControllerの起動
        present(alertController, animated: true, completion: nil)
    }
    
}

