//
//  TopViewPresenter.swift
//  TaskRTA
//
//  Created by Atsushi Otsubo on 2019/07/25.
//  Copyright © 2019 Rirex. All rights reserved.
//

import Foundation

protocol TopView: NSObjectProtocol {
    func showCountdownView()
}

class TopPresenter {
    
    let taskModel = TaskModel()
    weak fileprivate var topView: TopView?
    let uiFeedBack = UIFeedbackService.shared
    var runningTask: Task? {
        get {
            if let latestTask = taskModel.readAll().last {
                if latestTask.finishDate == nil {
                    return latestTask
                }
            }
            return nil
        }
    }
    
    func attachView(_ view: TopView) {
        self.topView = view
        if runningTask != nil {
            topView?.showCountdownView()
        }
    }
    
    func detachView() {
        self.topView = nil
    }
    
    func makeTask(taskName: String, targetDate: Date) {
        let now = Date()
        let task = Task(name: taskName, progress: 0, startDate: now, targetDate: targetDate, finishDate: nil)
        taskModel.save(task: task, isUpdate: false)
        topView?.showCountdownView()
    }
}
