//
//  CompleteTaskViewModel.swift
//  TaskRTA
//
//  Created by Mercury on 2019/07/25.
//  Copyright © 2019 Rirex. All rights reserved.
//

class CompleteTaskViewModel {
    
    let taskModel = TaskModel()
    
    func save(task: Task) {
        taskModel.save(task: task)
    }
    
    func delete(task: Task) {
        taskModel.delete(task: task)
    }
    
    func readAll() -> [Task] {
        return taskModel.readAll()
    }
}
