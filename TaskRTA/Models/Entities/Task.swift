//
//  Task.swift
//  TaskRTA
//
//  Created by Mercury on 2019/07/25.
//  Copyright © 2019 Rirex. All rights reserved.
//
import Foundation

struct Task {
    var uuid: String
    var name: String
    var progress: Float
    var startDate: Date
    var targetDate: Date
    var finishDate: Date?
    
    init(name: String, progress: Float, startDate: Date, targetDate: Date, finishDate: Date?) {
        self.uuid = NSUUID().uuidString
        self.name = name
        self.progress = progress
        self.startDate = startDate
        self.targetDate = targetDate
        self.finishDate = finishDate
    }
    
    init(uuid: String, name: String, progress: Float, startDate: Date, targetDate: Date, finishDate: Date?) {
        self.uuid = uuid
        self.name = name
        self.progress = progress
        self.startDate = startDate
        self.targetDate = targetDate
        self.finishDate = finishDate
    }
}
