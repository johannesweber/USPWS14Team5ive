//
//  GoalsTableViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 01.12.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit


class GoalsTableViewController: UITableViewController, AddGoalTableViewControllerDelegate {
    
    func addGoalTableViewControllerDidCancel(controller: AddGoalTableViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
//    //TODO methode fertigstellen wenn goals erstellt werden können
    func addGoalTableViewController(controller: AddGoalTableViewController,
        didFinishAddingItem item: TableItem) {
//        
//        let newRowIndex = items.count
//        items.append(item)
//        let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
//        let indexPaths = [indexPath]
//        tableView.insertRowsAtIndexPaths(indexPaths,
//        withRowAnimation: .Automatic)
//        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue,
        sender: AnyObject?) {
        
        // 1
        if segue.identifier == "AddGoal" {
            // 2
            let navigationController = segue.destinationViewController
            as UINavigationController
            // 3
            let controller = navigationController.topViewController
            as AddGoalTableViewController
            // 4
            controller.delegate = self
        }
    }
}
    

