//
//  CountdownViewModel.swift
//  TaskRTA
//
//  Created by Mercury on 2019/07/25.
//  Copyright © 2019 Rirex. All rights reserved.
//

class CountdownViewModel {
    
    let taskModel = TaskModel()
    
    func update(task: Task) {
        taskModel.save(task: task, isUpdate: true)
    }
    
    func readRunningTask() -> Task? {
        if let latestTask = taskModel.readAll().last {
            if latestTask.finishDate == nil {
                return latestTask
            }
        }
        return nil
    }
}
