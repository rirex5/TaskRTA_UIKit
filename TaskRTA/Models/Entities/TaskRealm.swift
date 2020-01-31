//
//  TaskRealmModel
//  TaskRTA
//
//  Created by Atsushi Otsubo on 2019/07/25.
//  Copyright © 2019 Rirex. All rights reserved.
//

import RealmSwift

class TaskRealm: Object {
    @objc dynamic var uuid: String = ""
    @objc dynamic var taskName: String = ""
    @objc dynamic var progress: Float = -1
    @objc dynamic var startDate: Date = Date(timeIntervalSince1970: 0)
    @objc dynamic var targetDate: Date = Date(timeIntervalSince1970: 0)
    @objc dynamic var finishDate: Date?
    
    override static func primaryKey() -> String? {
        return "uuid"
    }
    
    func set(task: Task) {
        uuid = task.uuid
        taskName = task.name
        progress = task.progress
        startDate = task.startDate
        targetDate = task.targetDate
        finishDate = task.finishDate
    }
    
}
