//
//  TaskListViewController.swift
//  ToDoApp
//
//  Created by Valeriy Trusov on 05.05.2022.
//

import UIKit

class TaskListViewController: UIViewController {

    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var dataProvider: DataProvider!
    
    @IBAction func addNewTask(sender: UIBarButtonItem) {
        
        if let viewController = storyboard?.instantiateViewController(withIdentifier: String(describing: NewTaskViewController.self)) as? NewTaskViewController {
            viewController.taskManager = self.dataProvider.taskManager
            viewController.delegate = self
            self.present(viewController, animated: true)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let taskManager = TaskManager()
        dataProvider.taskManager = taskManager
        
        NotificationCenter.default.addObserver(self, selector: #selector(showDetails(withNotifications:)), name: Notification.Name(rawValue: "DidSelectRow notification"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        tableView.reloadData()
    }
                                               
    @objc func showDetails(withNotifications notification:Notification) {
            
        guard let userInfo = notification.userInfo,
              let task = userInfo["task"] as? Task,
              let detailViewController = storyboard?.instantiateViewController(withIdentifier: String(describing: DetailViewController.self)) as? DetailViewController else { fatalError()
              }
        
        detailViewController.task = task
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
}

