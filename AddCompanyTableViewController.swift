//
//  AddDeviceViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 02.12.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit

protocol AddCompanyTableViewControllerDelegate: class {
    
    func addCompanyTableViewControllerDidCancel(controller: AddCompanyTableViewController)
    func addCompanyTableViewController(controller: AddCompanyTableViewController, didFinishAddingItem item: TableItem)
}

class AddCompanyTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
        
        //Variables
        
        var companyPickerVisible = false
        var company: [TableItem]
        var companySelected = String()
        
        weak var delegate: AddCompanyTableViewControllerDelegate?
        
        //initializer
        
        required init(coder aDecoder: NSCoder) {
            
            self.company = [TableItem]()
            
            let row0item = TableItem(name: "Fitbit", nameInDatabase: "fitbit")
            self.company.append(row0item)
            
            let row1item = TableItem(name: "Medisana", nameInDatabase: "medisana")
            self.company.append(row1item)
            
            let row2item = TableItem(name: "Withings", nameInDatabase: "withings")
            self.company.append(row2item)
            
            super.init(coder: aDecoder)
        }
        
        //IBOutlet
        
        @IBOutlet weak var cancelBarButton: UIBarButtonItem!
        @IBOutlet weak var addBarButton: UIBarButtonItem!
        
        //IBAction
        
        @IBAction func cancel(sender: UIBarButtonItem) {
            
            self.delegate?.addCompanyTableViewControllerDidCancel(self)
        }
        
        //TODO disable done button if no company is added
        @IBAction func add(sender: UIBarButtonItem) {
            
            println(self.companySelected)
            
            let newTableItem = TableItem(name: self.companySelected)
            
            self.delegate?.addCompanyTableViewController(self, didFinishAddingItem: newTableItem)
            
        }
        
        //methods
        
        func showCompanyPicker() {
            
            self.companyPickerVisible = true
            
            let indexPathCompanyPicker = NSIndexPath(forRow: 1, inSection: 0)
            self.tableView.insertRowsAtIndexPaths([indexPathCompanyPicker], withRowAnimation: .Fade)
            
            if let pickerCell = tableView.cellForRowAtIndexPath(indexPathCompanyPicker) {
                
                let companyPicker = pickerCell.viewWithTag(222) as UIPickerView
            }
        }
        
        func hideCompanyPicker() {
                    
            if self.companyPickerVisible {
            
                self.companyPickerVisible = false
                let indexPathCompanyRow = NSIndexPath(forRow: 0, inSection: 0)
                let indexPathCompanyPicker = NSIndexPath(forRow: 1, inSection: 0)
            
                tableView.beginUpdates()
                tableView.reloadRowsAtIndexPaths([indexPathCompanyRow], withRowAnimation: .None)
                tableView.deleteRowsAtIndexPaths([indexPathCompanyPicker], withRowAnimation: .Fade)
                tableView.endUpdates()
            
            }
        }

        
        //Picker View Methods
        
        func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
            
            return 1
        }
        
        func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
                
                return self.company.count
        }
        
        func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
                    
            return self.company[row].name
        }
        
        func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
                        
            self.companySelected = self.company[row].name
            self.addBarButton.enabled = true
        }
        
        
        //Override Functions
        
        override func viewDidLoad() {
            
            super.viewDidLoad()
            self.tableView.rowHeight = 44
            
            self.showCompanyPicker()
            
            self.addBarButton.enabled = false
            
        }
        
        override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
            if indexPath.section == 0 && indexPath.row == 1 {
            
                var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("CompanyPickerCell") as? UITableViewCell
            
                    if cell == nil {
                    
                        cell = UITableViewCell(style: .Default, reuseIdentifier: "CompanyPicker")
                        cell.selectionStyle = .None
                
                        let companyPicker = UIPickerView (frame: CGRect(x: 0, y: 0, width: 320, height: 216))
                        companyPicker.tag = 222
                        companyPicker.dataSource = self
                        companyPicker.delegate = self
                        cell.contentView.addSubview(companyPicker)
                    }
            
                    return cell
            
            } else {
            
                return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
            
            }
        }
        
        override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                
            if section == 0 && self.companyPickerVisible {
            
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
            
                if !self.companyPickerVisible {
                    
                    showCompanyPicker()
                    
                } else {
                    
                    hideCompanyPicker()
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
