//
//  Task.swift
//  toDO
//
//  Created by Mercury on 2019/07/25.
//  Copyright © 2019 Rirex. All rights reserved.
//
import Foundation

struct Task {
    var uuid: String
    var name: String
    var progress: Float
    var date: Date
    
    init(name: String, progress: Float, date: Date) {
        self.uuid = NSUUID().uuidString
        self.name = name
        self.progress = progress
        self.date = date
    }
    
    init(uuid: String, name: String, progress: Float, date: Date) {
        self.uuid = uuid
        self.name = name
        self.progress = progress
        self.date = date
    }
}
