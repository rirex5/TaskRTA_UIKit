//
//  CountdownPresenter.swift
//  TaskRTA
//
//  Created by Atsushi Otsubo on 2019/07/25.
//  Copyright © 2019 Rirex. All rights reserved.
//

import Foundation

protocol CountdownView: NSObjectProtocol {
    func setTaskName(_ name: String)
    func updateCountdownTime(startDate: Date, targetDate: Date)
}

class CountdownPresenter {
    
    let taskModel = TaskModel()
    var countdownTimer: Timer!
    weak fileprivate var countdownView: CountdownView?
    let vibrationService = VibrationService.shared
    var _runningTask: Task? // キャッシュ用
    var runningTask: Task? {
        get {
            if _runningTask != nil {
                return _runningTask
            }
            if let latestTask = taskModel.readAll().last {
                if latestTask.finishDate == nil {
                    _runningTask = latestTask
                    return latestTask
                }
            }
            return nil
        }
    }
    
    func attachView(_ view: CountdownView) {
        self.countdownView = view
        // 初期化
        guard let task = runningTask else { return }
        countdownView?.setTaskName(task.name)
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(CountdownPresenter.timerUpdate), userInfo: nil, repeats: true)
        countdownView?.updateCountdownTime(startDate: task.startDate, targetDate: task.targetDate)
    }
    
    func detachView() {
        self.countdownView = nil
    }
    
    @objc func timerUpdate() {
        let now = Date()
        guard let task = runningTask else { return }
        countdownView?.updateCountdownTime(startDate: task.startDate, targetDate: task.targetDate)
        if Int(now.timeIntervalSince1970) - 1 == Int(task.targetDate.timeIntervalSince1970) {
            vibrationService.startVibrate(times: 5)
        }
    }
    
    func taskFinish(progress: Float) {
        vibrationService.stopVibrate()
        countdownTimer.invalidate()
        if runningTask != nil {
            var task = runningTask!
            task.progress = progress
            let now = Date()
            task.finishDate = now
            taskModel.save(task: task, isUpdate: true)
        }
     }
}
