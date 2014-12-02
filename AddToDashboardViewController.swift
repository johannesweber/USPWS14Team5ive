//
//  AddToDashboardViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 30.11.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit

class AddToDashboardViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var measurementPicker: UIPickerView!
    
    var itemSelected = String()
    
    var measurement = ["Steps", "Duration", "Distance", "Calories burned", "Elevation", "Body Weight", "Body Height", "BMI", "Body Fat", "Blood Pressure", "Heart Rate", "Glucose", "Food", "Water", "Calories eaten", "Sleep Analysis"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.measurementPicker.dataSource = self
        self.measurementPicker.delegate = self
        
        self.itemSelected = measurement[0]
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.measurement.count
    }


    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return self.measurement[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.itemSelected = self.measurement[row]
    }

    @IBAction func addClicked(sender: AnyObject) {
        println(self.itemSelected)
    }
    
}
