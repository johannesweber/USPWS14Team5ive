//
//  DevicesTableViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 02.12.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit

class CompaniesTableViewController: UITableViewController, AddCompanyTableViewControllerDelegate {
    
    //variables
    
    var companyItems: [TableItem]
    
    //initializers
    
    required init(coder aDecoder: NSCoder) {
    
        self.companyItems = [TableItem]()
    
        super.init(coder: aDecoder)
        println(documentsDirectory())
    }
    
    
    //methods to save data in the documents folder
    func documentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(
        .DocumentDirectory, .UserDomainMask, true) as [String]
        return paths[0]
    }
    
    func dataFilePath() -> String {
            return documentsDirectory().stringByAppendingPathComponent("UserCompanies.plist")
    }
    
    func saveCompanyAccountItems() {
        let dataToSave = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: dataToSave)
        archiver.encodeObject(companyItems, forKey: "UserCompany")
        archiver.finishEncoding()
        dataToSave.writeToFile(dataFilePath(), atomically: true)
    }
    
    //function to load data
    
    func loadCompanyItems() {
            // 1
            let path = dataFilePath()
            // 2
            if NSFileManager.defaultManager().fileExistsAtPath(path) {
            // 3
                if let data = NSData(contentsOfFile: path) {
                let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
                companyItems = unarchiver.decodeObjectForKey("UserCompany") as [TableItem]
                unarchiver.finishDecoding() }
            } }
    
    //override methods
    
    override func viewDidLoad() {
        loadCompanyItems()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.companyItems.count
    }
    
    //places the TableItems in tableview rows
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return nil
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CompanyItem") as UITableViewCell
        
        let item = self.companyItems[indexPath.row]
        
        let label = cell.viewWithTag(4060) as UILabel
        label.text = item.name
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        self.companyItems.removeAtIndex(indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
                    saveCompanyAccountItems()
    }
    
    //sets the delegate for AddToDashboardtableViewController
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "goToAddCompany" {
            
            let navigationController = segue.destinationViewController as UINavigationController
            let controller = navigationController.topViewController as AddCompanyTableViewController
            
            controller.delegate = self
        }
    }

    
    
    // Delegate Methods
    func addCompanyTableViewControllerDidCancel(controller: AddCompanyTableViewController) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func addCompanyTableViewController(controller: AddCompanyTableViewController, didFinishAddingItem item: TableItem) {
        let newRowIndex = self.companyItems.count
        
        let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
        let indexPaths = [indexPath]
        
        if companyItems.contains(item){
        
            println("FOUND")
        
            showAlert("Company already added.", "The chosen company has already been added to your list. The action can't be executed.", self)
        
        } else {
        
            println("NOT FOUND")
        
            self.companyItems.append(item)
        
            self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        saveCompanyAccountItems()
                
        switch item.name {
            case "Withings":
                var withings = Withings()
                withings.doOAuth()
                break;
            case "Medisana":
                var medisana = Medisana()
                medisana.doOAuth()
                break;
            case "Fitbit":
                var fitbit = Fitbit()
                fitbit.doOAuth()
                break;
            default:
            println("hallo")
                break;
        }
                
                
                
        
    }

}
