//
//  CompleteTaskViewController.swift
//  TaskRTA
//
//  Created by Mercury on 2019/07/23.
//  Copyright © 2019 Rirex. All rights reserved.
//

import UIKit

class CompleteTaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var completeTaskTableView: UITableView!
    let presenter = CompleteTaskPresenter()
    
    override func viewWillAppear(_ animated: Bool) {
        initialization()
        presenter.attachView(self)
        completeTaskTableView.reloadData()
    }
    
    func initialization() {
        completeTaskTableView.register(UINib(nibName: "CompleteTaskTableViewCell", bundle: nil), forCellReuseIdentifier: "CompleteTaskTableViewCell")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.tasks.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if presenter.tasks[section].count != 0 {
            let finishDate = presenter.tasks[section][0].finishDate?.toStringOnlyDate()
            return finishDate
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.tasks[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompleteTaskTableViewCell") as! CompleteTaskTableViewCell
        let taskName = presenter.tasks[indexPath.section][indexPath.row].name
        let progressPercent = presenter.tasks[indexPath.section][indexPath.row].progress * 100.0
        let startDate = presenter.tasks[indexPath.section][indexPath.row].startDate
        let finishDate = presenter.tasks[indexPath.section][indexPath.row].finishDate
        
        cell.taskNameLabel.text = taskName
        
        if (progressPercent > 99.0) {
            cell.progressLabel.text = "✔︎"
            cell.progressLabel.font = UIFont.systemFont(ofSize: 30)
        } else {
            cell.progressLabel.text = String(format: "%.0f", progressPercent) + " %"
            cell.progressLabel.font = UIFont.systemFont(ofSize: 17)
        }
        
        cell.timeLabel.text = finishDate!.timeIntervalSince(startDate).toStringDateFormat()
        
        return cell
    }
    
    //セルの編集許可
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    //スワイプしたセルを削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let task = presenter.tasks[indexPath.section][indexPath.row]
            presenter.delete(task: task)
            presenter.tasks[indexPath.section].remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
        }
    }
    
}

extension CompleteTaskViewController: CompleteTaskView { }

extension Date {
    func toStringOnlyDate() -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
}

extension TimeInterval {
    func toStringDateFormat() -> String {
        let time = Int(self)
        let hour = Int(floor(Double(time) / 3600.0))
        let minute = Int(floor(Double(time % 3600) / 60.0))
        let second = Int(time % 60)
        var outputTime = ""
        if (hour == 0) {
            outputTime = String(format: "%02d:%02d", minute, second)
        } else {
            outputTime = String(format: "%02d:%02d:%02d", hour, minute, second)
        }
        return outputTime
    }
}

