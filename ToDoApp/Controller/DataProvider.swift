//
//  DataProvider.swift
//  ToDoApp
//
//  Created by Valeriy Trusov on 08.05.2022.
//

import Foundation
import UIKit


enum Section: Int, CaseIterable {
    
    case toDo
    case Done
}

class DataProvider: NSObject {
    
    var taskManager: TaskManager?
    
}


extension DataProvider: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        
        guard let section = Section(rawValue: indexPath.section) else { fatalError()}
                
                switch section {
                case .toDo:
                    return "Done"
                case .Done:
                    return "Undone"
                }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let section = Section(rawValue: indexPath.section) else { fatalError()}
           
                
                switch section {
                case .toDo:
                    let task = taskManager?.task(at: indexPath.row)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DidSelectRow notification"), object: self, userInfo: ["task": task])
                case .Done:
                    break
                }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section \(section)"
    }
}


extension DataProvider: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let section = Section(rawValue: section) else { fatalError() }
        
        guard let taskManager = taskManager else { return 0 }
        
        switch section {
            
        case .toDo: return taskManager.tasksCount
        case .Done: return taskManager.doneTasksCount
        
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TaskCell.self), for: indexPath) as! TaskCell
        
        guard let section = Section(rawValue: indexPath.section) else { fatalError() }
        guard let taskManager = taskManager else { fatalError() }
        
        let task: Task
        
        switch section {
        case .toDo: task = taskManager.task(at: indexPath.row)
        case .Done: task = taskManager.doneTask(at: indexPath.row)
        }
        
        cell.configure(withTask: task, done: task.isDone)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard
            let section = Section(rawValue: indexPath.section),
            let taskManager = taskManager else { fatalError() }
        
        switch section {
            
        case .toDo: taskManager.checkTask(at: indexPath.row)
        case .Done: taskManager.uncheckTask(at: indexPath.row)
        }
        
        tableView.reloadData()
    }
}
