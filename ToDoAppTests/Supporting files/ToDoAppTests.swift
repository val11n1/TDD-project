//
//  ToDoAppTests.swift
//  ToDoAppTests
//
//  Created by Valeriy Trusov on 05.05.2022.
//

import XCTest
@testable import ToDoApp

class ToDoAppTests: XCTestCase {

    override func setUp()  {
        super.setUp()
    }

    override func tearDown()  {
        super.tearDown()
    }

    func testInitialViewControllerIsTaskListViewController() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateInitialViewController() as! UINavigationController
        let rootViewController = navigationController.viewControllers.first as! TaskListViewController
        
        XCTAssertTrue(rootViewController is TaskListViewController)
    }
}
