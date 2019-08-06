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
    let viewModel = CompleteTaskViewModel()
    var tasks: [[Task]] = [[]]
    
    override func viewWillAppear(_ animated: Bool) {
        initialization()
        completeTaskTableView.reloadData()
    }
    
    func initialization() {
        let taskAll = viewModel.readAll()
        tasks = [[]]
        var previousTask: Task?
        var j = 0
        for (i, task) in taskAll.enumerated() {
            if (i == 0) {
                tasks[j].append(task)
            } else {
                if (task.finishDate.toStringOnlyDate() != previousTask?.finishDate.toStringOnlyDate()) {
                    tasks.append([])
                    j += 1
                }
                tasks[j].insert(task, at: 0)
            }
            previousTask = task
        }
        tasks.reverse()
        completeTaskTableView.register(UINib(nibName: "CompleteTaskTableViewCell", bundle: nil), forCellReuseIdentifier: "CompleteTaskTableViewCell")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tasks[section].count != 0 {
            let finishDate = tasks[section][0].finishDate.toStringOnlyDate()
            return finishDate
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompleteTaskTableViewCell") as! CompleteTaskTableViewCell
        let taskName = tasks[indexPath.section][indexPath.row].name
        let progressPercent = tasks[indexPath.section][indexPath.row].progress * 100.0
        cell.taskNameLabel.text = taskName
        if (progressPercent > 99.0) {
            cell.progressLabel.text = "✔︎"
            cell.progressLabel.font = UIFont.systemFont(ofSize: 30)
        } else {
            cell.progressLabel.text = String(format: "%.0f", progressPercent) + " %"
            cell.progressLabel.font = UIFont.systemFont(ofSize: 17)
        }
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
            let task = tasks[indexPath.section][indexPath.row]
            viewModel.delete(task: task)
            tasks[indexPath.section].remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
        }
    }
    
}

extension Date {
    func toStringOnlyDate() -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
}
