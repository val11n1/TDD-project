//
//  TaskCellTableViewCell.swift
//  ToDoApp
//
//  Created by Valeriy Trusov on 08.05.2022.
//

import UIKit

class TaskCell: UITableViewCell {


    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    private var dateFormatter: DateFormatter {
        
        let dateFormetter = DateFormatter()
        dateFormetter.dateFormat  = "dd.MM.yy"
        return dateFormetter
    }
    
    func configure(withTask task: Task, done: Bool = false) {
        
        if done {
            
            let attributedString = NSAttributedString(string: task.title, attributes: [NSAttributedString.Key.strikethroughStyle : NSUnderlineStyle.single.rawValue])
            titleLabel.attributedText = attributedString
            
            dateLabel.text = ""
            locationLabel.text = ""
            
        }else {
            
            self.titleLabel.text = task.title
            
            let dateString = dateFormatter.string(from: task.date )
            dateLabel.text = dateString
            locationLabel.text = task.location?.name
        }
        
       
    }
}
