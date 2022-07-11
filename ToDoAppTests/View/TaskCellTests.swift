//
//  TaskCellTests.swift
//  ToDoAppTests
//
//  Created by Valeriy Trusov on 09.05.2022.
//

import XCTest
@testable import ToDoApp

class TaskCellTests: XCTestCase {

    var cell: TaskCell!
    
    override func setUp()  {
        
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: String(describing: TaskListViewController.self)) as! TaskListViewController
        
        controller.loadViewIfNeeded()
        
        let tableview = controller.tableView
        let dataSource = FakeDataSource()
        
        tableview?.dataSource = dataSource
        
        cell = tableview?.dequeueReusableCell(withIdentifier: String(describing: TaskCell.self), for: IndexPath(row: 0, section: 0)) as? TaskCell
        
    }

    override func tearDown()  {
        super.tearDown()
    }

    func testCellHasTitleLabel() {
        
        
        XCTAssertNotNil(cell.titleLabel)
    }
    
    func testCellHasTitleLabelInContentView() {
        
        
        XCTAssertTrue(cell.titleLabel.isDescendant(of: cell.contentView))
    }
    
    func testCellHasLocationLabel() {
        
        
        XCTAssertNotNil(cell.locationLabel)
    }
    
    func testCellHasLocationLabelInContentView() {
        
        
        XCTAssertTrue(cell.locationLabel.isDescendant(of: cell.contentView))
    }
    
    func testCellHasDateLabel() {
        
        
        XCTAssertNotNil(cell.dateLabel)
    }
    
    func testCellHasDateLabelInContentView() {
        
        
        XCTAssertTrue(cell.dateLabel.isDescendant(of: cell.contentView))
    }
    
    func testConfigureSetsTitle() {
        
        let task = Task(title: "Foo")
        cell.configure(withTask: task)
        
        XCTAssertEqual(cell.titleLabel.text, task.title)
    }
    
    func testConfigureSetsDate() {
        
        let task = Task(title: "Foo")
        cell.configure(withTask: task)
        
        let dateFormatter = DateFormatter()
        //http://nsdateformatter.com
        dateFormatter.dateFormat = "dd.MM.yy"
        let date = task.date
        let dateString = dateFormatter.string(from: date)
        
        XCTAssertEqual(cell.dateLabel.text, dateString)
    }
    
    func testConfigureSetsLocation() {
        
        let location = Location(name: "Bar")
        let task = Task(title: "Foo", location: location)
        cell.configure(withTask: task)
        
        XCTAssertEqual(cell.locationLabel.text, task.location?.name)
    }
    
    func configureCellWithTask() {
        
        let task = Task(title: "Foo")
        cell.configure(withTask: task, done: true)
    }
    
    func testDoneTaskShoulStrikeThrough() {
        
        configureCellWithTask()
        
        let attributedString = NSAttributedString(string: "Foo", attributes: [NSAttributedString.Key.strikethroughStyle : NSUnderlineStyle.single.rawValue])
        
        XCTAssertEqual(cell.titleLabel.attributedText, attributedString)
    }
    
    func testDoneTestDateLabelTextEqualsEmptyString() {
        
        configureCellWithTask()
        XCTAssertEqual(cell.dateLabel.text, "")
    }
    
    func testDoneTestLocationLabelTextEqualsEmptyString() {
        
        configureCellWithTask()
        XCTAssertEqual(cell.locationLabel.text, "")
    }
}


extension TaskCellTests {
    
    class FakeDataSource: NSObject, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            return UITableViewCell()
        }
        
        
        
    }
}
