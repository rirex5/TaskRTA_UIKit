//
//  CompleteTaskViewController.swift
//  toDO
//
//  Created by Mercury on 2019/07/23.
//  Copyright © 2019 Rirex. All rights reserved.
//

import UIKit

class CompleteTaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var completeTaskTableView: UITableView!
    let viewModel = CompleteTaskViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        completeTaskTableView.reloadData()
    }
    
    func initialization() {
        completeTaskTableView.register(UINib(nibName: "CompleteTaskTableViewCell", bundle: nil), forCellReuseIdentifier: "CompleteTaskTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tasks = viewModel.readAll()
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tasks = viewModel.readAll()
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompleteTaskTableViewCell") as! CompleteTaskTableViewCell
        
        let taskName = tasks[indexPath.row].name
        let progressPercent = tasks[indexPath.row].progress * 100.0
        
        cell.taskNameLabel.text = taskName
        
        if (progressPercent > 99.0) {
            cell.progressLabel.text = "✔︎"
        } else {
            cell.progressLabel.text = String(format: "%.1f", progressPercent) + " %"
        }
        return cell
    }
}
