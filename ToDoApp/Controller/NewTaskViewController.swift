//
//  NewTaskViewController.swift
//  ToDoApp
//
//  Created by Valeriy Trusov on 10.05.2022.
//

import Foundation
import UIKit
import CoreLocation


class NewTaskViewController: UIViewController {
    
    var taskManager: TaskManager!
    var geocoder = CLGeocoder()
    var delegate: UIViewController!
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var dateTextField: UITextField!
    @IBOutlet var descriptionTextField: UITextField!
    @IBOutlet var adressTextField: UITextField!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    
    @IBAction func save() {
        
        let titleString = titleTextField.text
        let locationString = locationTextField.text
        let date = dateFormatter.date(from: dateTextField.text!)
        let descriptionString = descriptionTextField.text
        let adressString = adressTextField.text
        
        geocoder.geocodeAddressString(adressString!) { [unowned self] placemarks, error in
            
            let placemark = placemarks?.first
            let coordinate = placemark?.location?.coordinate
            let location = Location(name: locationString!, coordinate: coordinate)
            let task = Task(title: titleString!, description: descriptionString, date: date, location: location)
            self.taskManager.add(task: task)
            
            DispatchQueue.main.async {
                
                if let delegate = self.delegate {
                    
                    self.delegate.viewWillAppear(false)
                }
                
                self.dismiss(animated: true)
            }
        }
        
    }
    
    var dateFormatter: DateFormatter {
        
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yy"
        return df
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("here")
    }
}

