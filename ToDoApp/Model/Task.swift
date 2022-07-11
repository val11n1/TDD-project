//
//  Task.swift
//  ToDoApp
//
//  Created by Valeriy Trusov on 05.05.2022.
//

import Foundation


struct Task {
    
    let title: String
    let description: String?
    let location: Location?
    let date: Date
    var isDone = false
    
    var dict: [String: Any] {
        
        var dict: [String: Any] = [:]
        
        dict["title"] = title
        dict["description"] = description
        dict["date"] = date
        
        if let location = location {
            dict["location"] = location.dict
        }
        
        return dict
    }
    
    init(title: String, description: String? = nil,date: Date? = nil, location: Location? = nil) {
        
        self.title = title
        self.description = description
        self.date = date ?? Date()
        self.location = location
    }
}

extension Task: Equatable {
    
    static func == (lhs: Task, rhs: Task) -> Bool {
        
        if  lhs.title == rhs.title &&
            lhs.description == rhs.description &&
            lhs.location == rhs.location {
            
            return true
        }
        
        return false
    }
}


extension Task {
    
    typealias PListDictionary = [String: Any]
    init?(dict: PListDictionary) {
        
        self.title = dict["title"] as! String
        self.description = dict["description"] as? String
        self.date = dict["date"] as? Date ?? Date()
        
        if let locationDictionary = dict["location"] as? [String: Any] {
            
            self.location = Location(dict: locationDictionary)
        }else {
            
            self.location = nil
        }
    }
}
