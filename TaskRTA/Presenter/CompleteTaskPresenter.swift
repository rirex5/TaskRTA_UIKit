//
//  CompleteTaskPresenter.swift
//  TaskRTA
//
//  Created by Atsushi Otsubo on 2019/07/25.
//  Copyright © 2019 Rirex. All rights reserved.
//

import Foundation

protocol CompleteTaskView: NSObjectProtocol {
 }

class CompleteTaskPresenter {
    
    let taskModel = TaskModel()
    weak fileprivate var completeTaskView: CompleteTaskView?
    var tasks: [[Task]] = [[]]
    var taskAll: [Task] {
        get {
            return taskModel.readAll()
        }
    }
    
    func attachView(_ view: CompleteTaskView) {
        self.completeTaskView = view
        // 初期化
        let taskAll = taskModel.readAll()
        tasks = [[]]
        var previousTask: Task?
        var j = 0
        for (i, task) in taskAll.enumerated() {
            if (i == 0) {
                tasks[j].append(task)
            } else {
                if (task.finishDate!.toStringOnlyDate() != previousTask?.finishDate!.toStringOnlyDate()) {
                    tasks.append([])
                    j += 1
                }
                tasks[j].insert(task, at: 0)
            }
            previousTask = task
        }
        tasks.reverse()
    }
    
    func detachView() {
        self.completeTaskView = nil
    }
    
    func delete(task: Task) {
        taskModel.delete(task: task)
    }
}
