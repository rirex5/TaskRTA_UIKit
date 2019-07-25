//
//  TaskModel.swift
//  toDO
//
//  Created by Mercury on 2019/07/25.
//  Copyright © 2019 Rirex. All rights reserved.
//

import RealmSwift

class TaskModel: Object {
    
     var tasksResults: Results<TaskRealm>!
    
    // Save
    func save(task: Task) {
        let taskRealm = TaskRealm()
        taskRealm.set(task: task)
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(taskRealm)
            }
        } catch {}
    }
    
    // Read ALL
    func readAll() -> [Task] {
        var tasks: [Task] = []
        do {
            let realm = try Realm()
            tasksResults = realm.objects(TaskRealm.self)
            for taskRealm in tasksResults {
                let task = Task(name: taskRealm.taskName, progress: taskRealm.progress)
                tasks.append(task)
            }
        } catch {}
        return tasks
    }
    
}
