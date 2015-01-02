//
//  FitnessDiagramViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 01.12.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit
import QuartzCore
import Alamofire
import SwiftyJSON

class DiagramViewController: UIViewController, LineChartDelegate, ManageDataDetailViewControllerDelegate {

    //variables
    var lineChartLabel: UILabel
    var lineChart: LineChart?
    var dayLabel: UILabel
    var userId: Int
    var limit: Int
    var currentMeasurement: TableItem
    var currentDate: String
    
    required init(coder aDecoder: NSCoder) {
        
        self.lineChart = LineChart()
        self.lineChartLabel = UILabel()
        self.dayLabel = UILabel()
        self.userId = prefs.integerForKey("USERID") as Int
        self.limit = 1
        self.currentMeasurement = TableItem()
        var date = Date()
        self.currentDate = date.getCurrentDateAsString()
        
        super.init(coder: aDecoder)
    }
    
    //IBOutlets
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    
    //IBAction
    @IBAction func segmentChanged(sender: UISegmentedControl) {
        
        self.limit = self.convertClickedSegmentIntoLimit(sender.selectedSegmentIndex)
        
        self.lineChartLabel.text = ""
        self.lineChart!.clearAll()
        
        self.defineHeightForRow()
        
        self.buildDiagram()
        
        if self.limit != 1 {

            self.dayLabel.removeFromSuperview()
            self.addDataToLineChart()
            self.tableView.reloadData()
            
        } else {
            
            self.lineChart!.removeFromSuperview()
            self.lineChartLabel.removeFromSuperview()
            
            self.tableView.reloadData()
            
            self.dayLabel.text = "Test Test Test 123"
        }

    }
    
    @IBAction func add(sender: UIBarButtonItem) {
        
    }
    
    //override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.defineHeightForRow()
        
        self.tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        
        self.lineChartLabel.removeConstraints(lineChartLabel.constraints())
        self.lineChartLabel.setTranslatesAutoresizingMaskIntoConstraints(true)
        
        self.lineChart!.removeConstraints(lineChart!.constraints())
        self.lineChart!.setTranslatesAutoresizingMaskIntoConstraints(true)
        
        self.title = self.currentMeasurement.name
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.dayLabel.frame = CGRect(
            x: 0,
            y: 0,
            width: 320.0,
            height: 44)

        
        self.lineChartLabel.frame = CGRect(
            x: 20,
            y: 20,
            width: 280.0,
            height: 30)
        
        self.lineChart?.frame = CGRect(
            x: 20,
            y: 20,
            width: 280,
            height: 200)
    }
    
    /**
    * Line chart delegate method.
    */
    func didSelectDataPoint(x: CGFloat, yValues: Array<CGFloat>) {
        self.lineChartLabel.text = "x: \(x)     y: \(yValues)"
    }
    
    // manage data detail view controller delegate methods
    func manageDataDetailViewController(controller: ManageDataDetailViewController, didSelectItem item: TableItem) {
        
        self.currentMeasurement = item
    }
    
    // methods
    
    func defineHeightForRow(){
        
        if self.limit == 1 {
            
            self.tableView.rowHeight = 44
            
        } else {
            
            self.tableView.rowHeight = 240
            
        }
    }
    
    func buildDiagram() {
        
        self.lineChartLabel.textAlignment = NSTextAlignment.Center
        
        self.lineChart!.areaUnderLinesVisible = true
        self.lineChart!.labelsXVisible = false
        self.lineChart!.delegate = self
        self.lineChart!.axisInset = 30
    
    }
    
    func addDataToLineChart(){
        
        var company = "fitbit"
        
        var parameters: Dictionary<String, AnyObject> = [
            
            "measurement"   : "\(self.currentMeasurement.nameInDatabase)",
            "userId"        : "\(self.userId)",
            "limit"         : "\(self.limit)",
            "endDate"       : "\(self.currentDate)"
        ]

        Alamofire.request(.GET, "\(baseURL)/\(company)/time_series/", parameters: parameters)
            .responseSwiftyJSON { (request, response, json, error) in
                
                println(request)
                println(json)
                
                var data: Array<CGFloat> = []
                
                for (var i = 0; i < json.count; i++) {
                    
                    var value = CGFloat(json[i]["value"].intValue)
                    data.append(value)
                    
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    self.lineChart!.addLine(data)
                    
                }
                
        }

    }
    
    func convertClickedSegmentIntoString(clickedSegment: Int) -> String {
        
        var clickedSegment = clickedSegment
        var segmentString = String()
        
        switch clickedSegment {
            
        case 0: segmentString = "Day"
        case 1: segmentString = "Week"
        case 2: segmentString = "Month"
        case 3: segmentString = "Year"
        default: segmentString = "no segment clicked"
            
        }
        
        return segmentString
        
    }
    
    func convertClickedSegmentIntoLimit(clickedSegment: Int) -> Int {
        
        var clickedSegment = clickedSegment
        var limit = Int()
        
        switch clickedSegment {
            
        case 0: limit = 1
        case 1: limit = 7
        case 2: limit = 30
        case 3: limit = 365
        default: limit = -1
            
        }
        
        return limit
        
    }
}

//UITable View Delegate and Data Source extensions
extension DiagramViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            
        let cellIdentifier = "DiagramCell"
            
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as UITableViewCell!
            
        if cell == nil {
        
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier)
        }
            
            if self.limit != 1 {
                
                cell.contentView.addSubview(self.lineChartLabel)
                cell.contentView.addSubview(self.lineChart!)
                
            } else {
                
                self.dayLabel.textAlignment = NSTextAlignment.Center
                cell.contentView.addSubview(self.dayLabel)
            }
            
        return cell
    }
}

extension DiagramViewController: UITableViewDelegate {
    
}



