//
//  DataProviderTests.swift
//  ToDoAppTests
//
//  Created by Valeriy Trusov on 08.05.2022.
//

import XCTest
@testable import ToDoApp

class DataProviderTests: XCTestCase {

    var sut: DataProvider!
    var tableview: UITableView!
    
    var controller: TaskListViewController!
    
    override func setUp()  {
        
        super.setUp()
        
        sut = DataProvider()
        sut.taskManager = TaskManager()
        
        let stroryboard = UIStoryboard(name: "Main", bundle: nil)
        controller = stroryboard.instantiateViewController(identifier: String(describing: TaskListViewController.self)) as? TaskListViewController
        
        controller.loadViewIfNeeded()
        
        tableview = controller.tableView
        tableview.dataSource = sut
        tableview.delegate = sut
    }

    override func tearDown()  {
        sut.taskManager?.removeAll()
        super.tearDown()
    }


    func testNumberOfSectionIsTwo() {
        
        
        let numberOfSection = tableview.numberOfSections
        
        XCTAssertEqual(numberOfSection, 2)
    }
    
    func testNumberOfRowsInSectionZeroIsTaskCount() {
        
        sut.taskManager?.add(task: Task(title: "Foo"))
        
        XCTAssertEqual(tableview.numberOfRows(inSection: 0), 1)
        
        sut.taskManager?.add(task: Task(title: "Bar"))
        
        tableview.reloadData()
        
        XCTAssertEqual(tableview.numberOfRows(inSection: 0), 2)
    }
    
    func testNumberOfRowsInSectionOneIsDoneTaskCount() {
        
        
        sut.taskManager?.add(task: Task(title: "Foo"))
        sut.taskManager?.checkTask(at: 0)
        
        XCTAssertEqual(tableview.numberOfRows(inSection: 1), 1)
        
        sut.taskManager?.add(task: Task(title: "Bar"))
        sut.taskManager?.checkTask(at: 0)
        
        tableview.reloadData()
        
        XCTAssertEqual(tableview.numberOfRows(inSection: 1), 2)
    }
    
    func testCellForRowAtIndexPathReturnTaskCell() {
        
        sut.taskManager?.add(task: Task(title: "Foo"))
        tableview.reloadData()
        
        let cell = tableview.cellForRow(at: IndexPath(row: 0, section: 0))
        
        XCTAssertTrue(cell is TaskCell)
    }
    
    func testCellForRowAtIndexPathDequeuesCellFromTableView() {
        
        let mockTableView = MockTableView.mockTableview(withDataSource: sut)
        
        sut.taskManager?.add(task: Task(title: "Foo"))
        mockTableView.reloadData()
        
        _ = mockTableView.cellForRow(at: IndexPath(row: 0, section: 0))
        
        XCTAssertTrue(mockTableView.cellIsDequeued)
    }
    
    func testCellForRowInSectionZeroCallsConfigure() {
        
        
        let mockTableView = MockTableView.mockTableview(withDataSource: sut)
        
        let task = Task(title: "Foo")
        
        sut.taskManager?.add(task: task)
        mockTableView.reloadData()
        
        let cell = mockTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! MockTaskCell
        
        XCTAssertEqual(cell.task, task)
    }
    
    func testCellForRowInSectionOneCallsConfigure() {
        
        
        let mockTableView = MockTableView.mockTableview(withDataSource: sut)
        
        let task = Task(title: "Foo")
        let task2 = Task(title: "Bar")
        
        sut.taskManager?.add(task: task)
        sut.taskManager?.add(task: task2)
        sut.taskManager?.checkTask(at: 0)
        mockTableView.reloadData()
        
        let cell = mockTableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! MockTaskCell
        
        XCTAssertEqual(cell.task, task)
    }
    
    func testDeleteButtonTitleSectionZeroShowsDone() {
        
        let buttonTitle = tableview.delegate?.tableView?(tableview, titleForDeleteConfirmationButtonForRowAt: IndexPath(row: 0, section: 0))
        
        XCTAssertEqual(buttonTitle, "Done")
    }

    
    func testDeleteButtonTitleSectionOneShowsUndone() {
        
        let buttonTitle = tableview.delegate?.tableView?(tableview, titleForDeleteConfirmationButtonForRowAt: IndexPath(row: 0, section: 1))
        
        XCTAssertEqual(buttonTitle, "Undone")
    }
    
    func testCheckingTaskChecksInTaskManager() {
        
        let task = Task(title: "Foo")
        sut.taskManager?.add(task: task)
        
        tableview.dataSource?.tableView?(tableview, commit: .delete, forRowAt: IndexPath(row: 0, section: 0))
        
        XCTAssertEqual(sut.taskManager?.tasksCount, 0)
        XCTAssertEqual(sut.taskManager?.doneTasksCount, 1)

    }
    
    func testUncheckingTaskUnchecksInTaskManager() {
        
        let task = Task(title: "Foo")
        sut.taskManager?.add(task: task)
        sut.taskManager?.checkTask(at: 0)
        tableview.reloadData()
        
        tableview.dataSource?.tableView?(tableview, commit: .delete, forRowAt: IndexPath(row: 0, section: 1))
        
        XCTAssertEqual(sut.taskManager?.tasksCount, 1)
        XCTAssertEqual(sut.taskManager?.doneTasksCount, 0)

    }
}


extension DataProviderTests {
    
    class MockTableView: UITableView {
        
        var cellIsDequeued = false
        
        override func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell {
            
            cellIsDequeued = true
            
            return super.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        }
        
        static func mockTableview(withDataSource datasource: UITableViewDataSource) -> MockTableView {
            
            let mockTableView = MockTableView(frame: CGRect(x: 0, y: 0, width: 414, height: 896), style: .plain)
            mockTableView.dataSource = datasource
            mockTableView.register(MockTaskCell.self, forCellReuseIdentifier: String(describing: TaskCell.self))
            
            return mockTableView
        }
    }
    
    class MockTaskCell: TaskCell {
        
        var task: Task?
        
        override func configure(withTask task: Task, done: Bool = false) {
            
            self.task = task
        }
    }
}
