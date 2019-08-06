//
//  TaskModel.swift
//  TaskRTA
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
    
    // Delete
    func delete(task: Task) {
        do {
            let realm = try Realm()
            let taskRealm = realm.objects(TaskRealm.self).filter("uuid=%@", task.uuid).first!
            try realm.write {
                realm.delete(taskRealm)
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
                let task = Task(uuid: taskRealm.uuid, name: taskRealm.taskName, progress: taskRealm.progress, startDate: taskRealm.startDate, finishDate: taskRealm.finishDate)
                tasks.append(task)
            }
        } catch {}
        tasks.sort { $0.finishDate < $1.finishDate }
        return tasks
    }
}
