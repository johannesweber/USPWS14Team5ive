 //
 //  AddToDashboardViewController.swift
 //  USPWS14Team5ive
 //
 //  Created by Johannes Weber on 30.11.14.
 //  Copyright (c) 2014 Johannes Weber. All rights reserved.
 //
 
 import UIKit
 import CoreData
 
 protocol AddToDashboardTableViewControllerDelegate: class {
    
    func addToDashboardViewControllerDidCancel(controller: AddToDashboardTableViewController)
    func addToDashboardViewController(controller: AddToDashboardTableViewController, didFinishAddingItem item: MeasurementItem)
 }
 
 class AddToDashboardTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    //Variables
    var measurementPickerVisible: Bool
    var measurement: [MeasurementItem]
    var measurementSelected: MeasurementItem
    weak var delegate: AddToDashboardTableViewControllerDelegate?
    var managedObjectContext: NSManagedObjectContext?
    
    //initializer
    required init(coder aDecoder: NSCoder) {
        
        self.measurementPickerVisible = false
        self.measurement = [MeasurementItem]()
        self.measurementSelected = MeasurementItem()
        
        var steps = MeasurementItem(name: NSLocalizedString("Steps", comment: "Name for Measurement Item Steps"), nameInDatabase: "steps", unit: "steps", group: "Fitness")
        
        super.init(coder: aDecoder)
        
        self.measurement.append(steps)
    }
    
    //IBOutlet
    
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var measurementDetailLabel: UILabel!
    
    //IBAction
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        
        self.delegate?.addToDashboardViewControllerDidCancel(self)
    }
    
    //TODO disable done button if no measurment is added
    @IBAction func done(sender: UIBarButtonItem) {
        
        self.delegate?.addToDashboardViewController(self, didFinishAddingItem: self.measurementSelected)
        
    }
    
    //Picker View Methods
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return self.measurement.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        
        return self.measurement[row].name
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.measurementSelected = self.measurement[row]
        self.measurementDetailLabel.text = self.measurementSelected.name
        self.doneBarButton.enabled = true
    }
    
    func showMeasurementPicker() {
        
        self.measurementPickerVisible = true
        let indexPathDatePicker = NSIndexPath(forRow: 1, inSection: 0)
        tableView.insertRowsAtIndexPaths([indexPathDatePicker], withRowAnimation: .Fade)
        
        if let pickerCell = tableView.cellForRowAtIndexPath(indexPathDatePicker) {
            
            let datePicker = pickerCell.viewWithTag(111) as UIPickerView
        }
    }
    
    func hideMeasurementPicker() {
        
        if self.measurementPickerVisible {
            self.measurementPickerVisible = false
            let indexPathDateRow = NSIndexPath(forRow: 0, inSection: 0)
            let indexPathDatePicker = NSIndexPath(forRow: 1, inSection: 0)
            
            tableView.beginUpdates()
            tableView.reloadRowsAtIndexPaths([indexPathDateRow], withRowAnimation: .None)
            tableView.deleteRowsAtIndexPaths([indexPathDatePicker], withRowAnimation: .Fade)
            tableView.endUpdates()
            
        }
    }
    
    //Override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 44
        
        self.doneBarButton.enabled = false
        self.showMeasurementPicker()
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 && indexPath.row == 1 {
            
            var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("MeasurementPickerCell") as? UITableViewCell
            
            if cell == nil {
                
                cell = UITableViewCell(style: .Default, reuseIdentifier: "MeasurementPicker")
                cell.selectionStyle = .None
                
                let datePicker = UIPickerView (frame: CGRect(x: 0, y: 0, width: 320, height: 216))
                datePicker.tag = 111
                datePicker.dataSource = self
                datePicker.delegate = self
                cell.contentView.addSubview(datePicker)
            }
            return cell
            
        } else {
            return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 && self.measurementPickerVisible {
            
            return 2
            
        } else {
            
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0 && indexPath.row == 1 {
            return 217
        } else {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.section == 0 && indexPath.row == 0 {
            
            if !self.measurementPickerVisible {
                
                self.showMeasurementPicker()
                
            } else {
                
                self.hideMeasurementPicker()
            }
        }
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        if indexPath.section == 0 && indexPath.row == 0 {
            
            return indexPath
            
        } else {
            
            return nil
        }
    }
    
    override func tableView(tableView: UITableView, var indentationLevelForRowAtIndexPath indexPath: NSIndexPath) -> Int {
        
        if indexPath.section == 0 && indexPath.row == 1 {
            
            indexPath = NSIndexPath(forRow: 0, inSection: indexPath.section)
            
        }
        
        return super.tableView(tableView, indentationLevelForRowAtIndexPath: indexPath)
    }
    
 }
