//
//  TaskRealmModel
//  toDO
//
//  Created by Mercury on 2019/07/25.
//  Copyright © 2019 Rirex. All rights reserved.
//

import RealmSwift

class TaskRealm: Object {
    
    @objc dynamic var taskName: String = ""
    @objc dynamic var progress: Float = -1
    @objc dynamic var date: Date = Date(timeIntervalSince1970: 0)
    
    func set(task: Task) {
        taskName = task.name
        progress = task.progress
        date = task.date
    }
}
