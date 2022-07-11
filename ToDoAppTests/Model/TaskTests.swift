//
//  TaskTests.swift
//  ToDoAppTests
//
//  Created by Valeriy Trusov on 05.05.2022.
//

import XCTest
@testable import ToDoApp

class TaskTests: XCTestCase {


    func testInitTaskWithTitle() {
        
        let task = Task(title: "Foo")
        
        XCTAssertNotNil(task)
    }
    
    func testInitTaskWithTitleAndDescription() {
        
        let task = Task(title: "Foo", description: "Bar")
        
        XCTAssertNotNil(task)
    }
    
    func testWhenGivenTitleSetsTitle() {
        
       let task = Task(title: "Foo")
        
        XCTAssertEqual(task.title, "Foo")
    }
    
    func testWhenGivenDescriptionSetsDescriptions() {
        
        let task = Task(title: "Foo", description: "Bar")
        
        XCTAssertEqual(task.description, "Bar")
    }
    
    func testTaskInitWithDate() {
        
        let task = Task(title: "Foo")
        
        XCTAssertNotNil(task.date)
    }
    
    func testWhenGivenDescriptionSetsLocaton() {
        
        let location = Location(name: "Foo")
        
        let task = Task(title: "Bar", description: "Baz", location: location)
        
        XCTAssertEqual(location, task.location)
    }
    
    func testCanBeCreatedFromPListDictionary() {
        let date = Date(timeIntervalSince1970: 10)
        let location = Location(name: "Baz")
        let task = Task(title: "Foo", description: "Bar", date: date, location: location)
        
        let locationDictionary: [String: Any] = ["name": "Baz"]
        let dictionary: [String: Any] = ["title": "Foo",
                                         "description": "Bar",
                                         "date": date,
                                         "location": locationDictionary]
        
        let createdTask = Task(dict: dictionary)
        
        XCTAssertEqual(task, createdTask)
    }
    
    func testCanBeSerializedIntoDictionary() {
        
        let date = Date(timeIntervalSince1970: 10)
        let location = Location(name: "Baz")
        let task = Task(title: "Foo", description: "Bar", date: date, location: location)
        
        let generatedtask = Task(dict: task.dict)
        
        XCTAssertEqual(task, generatedtask)
    }
}
