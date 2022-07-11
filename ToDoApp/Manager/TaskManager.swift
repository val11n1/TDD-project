//
//  TaskManager.swift
//  ToDoApp
//
//  Created by Valeriy Trusov on 05.05.2022.
//

import Foundation
import UIKit

class TaskManager {
    
    
    private var tasksArray = [Task]()
    private var doneTasksArray = [Task]()
    
    var tasksCount: Int {
        
        return tasksArray.count
    }
    
    var doneTasksCount: Int {
        
        return doneTasksArray.count
    }
    
    var tasksURL: URL {
        
        let fileURLS = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        guard let documentURL = fileURLS.first else { fatalError() }
        
        return documentURL.appendingPathComponent("tasks.plist")
    }
    
    init() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(save), name: UIApplication.willResignActiveNotification, object: nil)
        
        if let data = try? Data(contentsOf: tasksURL) {
            
            let dictionaries = try? PropertyListSerialization.propertyList(from: data, format: nil) as! [[String: Any]]
            
            for dict in dictionaries! {
                
                if let task = Task(dict: dict) {
                    
                    tasksArray.append(task)
                }
            }
        }
    }
    
    deinit {
        save()
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func save() {
        
        let taskDict = self.tasksArray.map {$0.dict}
        guard taskDict.count > 0 else {
            
            try? FileManager.default.removeItem(at: tasksURL)
            return
        }
        
        let plistData = try? PropertyListSerialization.data(fromPropertyList: taskDict,
                                                            format: .xml,
                                                            options: PropertyListSerialization.WriteOptions(0))
        
        try? plistData?.write(to: tasksURL, options: .atomic)
    }
    
    func add(task: Task) {
        
        if !tasksArray.contains(task) {
        tasksArray.append(task)
        }
    }
    
    func task(at: Int) -> Task {

       return tasksArray[at]
    }
    
    func checkTask(at index: Int) {
        
        var task = tasksArray.remove(at: index)
        task.isDone.toggle()
        doneTasksArray.append(task)
    }
    
    func uncheckTask(at index: Int) {
        
        var task = doneTasksArray.remove(at: index)
        task.isDone.toggle()
        tasksArray.append(task)
    }
    
    func doneTask(at index: Int) -> Task {
        
       return doneTasksArray[index]
    }
    
    func removeAll() {
        
        tasksArray.removeAll()
        doneTasksArray.removeAll()
    }
}
