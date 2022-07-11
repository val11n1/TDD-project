//
//  TaskListViewControllerTests.swift
//  ToDoAppTests
//
//  Created by Valeriy Trusov on 06.05.2022.
//

import XCTest
@testable import ToDoApp

class TaskListViewControllerTests: XCTestCase {

    var sut: TaskListViewController!
    
    override func setUp()  {

        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: String(describing: TaskListViewController.self))
        
        sut = vc as? TaskListViewController
        sut.loadViewIfNeeded()
        
        //_ = sut.view // sut.loadViewIfNeeded()
    }

    override func tearDown()  {
        super.tearDown()
    }

 
    func testWhenViewIsLoadedTableViewNotNil() {
        
        
        XCTAssertNotNil(sut.tableView)
    }

    func testWhenViewIsLoadedDataProviderIsNotNill() {
        
        XCTAssertNotNil(sut.dataProvider)
    }
    
    func testWhenViewIsLoadedTableViewDelegateIsSet() {
        
        XCTAssertTrue(sut.tableView.delegate is DataProvider)
    }
    
    func testWhenViewIsLoadedTableViewDataSourceIsSet() {
        
        XCTAssertTrue(sut.tableView.dataSource is DataProvider)
    }

    
    func testWhenViewIsLoadedTableViewDelegateEqualsTableViewDataSource() {
        
        XCTAssertEqual(sut.tableView.delegate as? DataProvider,
                       sut.tableView.dataSource as? DataProvider)
    }
    

    func testTaskListVCHasAddBarButtonWithSelfAsTarget() {
        
        let target = sut.navigationItem.rightBarButtonItem?.target
        
        XCTAssertEqual(target as? TaskListViewController, sut)
    }
    
    func presentingNewTaskViewController() -> NewTaskViewController {
        
        
        guard let newTaskButton = sut.navigationItem.rightBarButtonItem,
              let action = newTaskButton.action else {
            
            return NewTaskViewController()
        }
        
        UIApplication.shared.keyWindow?.rootViewController = sut
        sut.performSelector(onMainThread: action, with: newTaskButton, waitUntilDone: true)
        
        let newTaskVC = sut.presentedViewController as! NewTaskViewController
        newTaskVC.delegate = sut
        return newTaskVC
    }
    
    func testAddNewTaskPresentsNewTaskViewController() {
        
        let newTaskViewCOntroller = presentingNewTaskViewController()
        XCTAssertNotNil(newTaskViewCOntroller.titleTextField)
    }
    
    
    func testSharesSameTaskManagerWithNewTaskVC() {
        
        let newTaskViewController = presentingNewTaskViewController()
        
        XCTAssertNotNil(sut.dataProvider.taskManager)
        XCTAssertTrue(newTaskViewController.taskManager === sut.dataProvider.taskManager)
    }

    func testWhenViewAppearedTableViewReloaded() {
        
        let mockTableView = MockTableView()
        sut.tableView = mockTableView
        
        sut.beginAppearanceTransition(true, animated: true)
        sut.endAppearanceTransition()
        
        XCTAssertTrue((sut.tableView as! MockTableView).isReloaded)
    }
    
    func testTappingCellSendsNotification() {
        
        let task = Task(title: "Foo")
        sut.dataProvider.taskManager!.add(task: task)
        
        expectation(forNotification: NSNotification.Name(rawValue: "DidSelectRow notification"), object: nil) { notification -> Bool in
            
            guard let taskFromNotification = notification.userInfo?["task"] as? Task else { return false }
            
            return task == taskFromNotification
        }
        
        let tableview = sut.tableView
        tableview?.delegate?.tableView?(tableview!, didSelectRowAt: IndexPath(row: 0, section: 0))
        
        waitForExpectations(timeout: 1)
    }
    
    func testSelectedCellNotificationPushesDetailVC() {
        
        let mockNav = MockNavigationController(rootViewController: sut)
        UIApplication.shared.keyWindow?.rootViewController = mockNav
        
        sut.loadViewIfNeeded()
        let task = Task(title: "Foo")
        let task1 = Task(title: "Bar")
        
        sut.dataProvider.taskManager?.add(task: task)
        sut.dataProvider.taskManager?.add(task: task1)
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "DidSelectRow notification"), object: self, userInfo: ["task": task1])
        
        guard let detailViewController = mockNav.pushedViewController as? DetailViewController else {
            
            XCTFail()
            return
        }
        
        detailViewController.loadViewIfNeeded()
        XCTAssertNotNil(detailViewController.titleLabel)
        XCTAssertTrue(detailViewController.task == task1)
    }
}


extension TaskListViewControllerTests {
    
    class MockTableView: UITableView {
        
        var isReloaded = false
        
        override func reloadData() {
            isReloaded = true
        }
    }
}

extension TaskListViewControllerTests {
    
    class MockNavigationController: UINavigationController {
        
        var pushedViewController: UIViewController?
        
        override func pushViewController(_ viewController: UIViewController, animated: Bool) {
            pushedViewController = viewController
            super.pushViewController(viewController, animated: animated)
        }
    }
}
