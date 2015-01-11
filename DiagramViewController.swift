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

class DiagramViewController: UIViewController, LineChartDelegate {

    //variables
    var lineChart: LineChart?
    var lineChartLabel = UILabel()
    var dayLabel = UILabel()
    var userId = prefs.integerForKey("USERID") as Int
    var limit = 1
    var currentMeasurement: Measurement!
    var date = Date()
    
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
            self.addDataLineToChart()
            self.tableView.reloadData()
            
        } else {
            
            self.lineChart!.removeFromSuperview()
            self.lineChartLabel.removeFromSuperview()

            self.tableView.reloadData()
            
            self.createTextForDayTab()
        }

    }
    
    @IBAction func add(sender: UIBarButtonItem) {
        
    }
    
    //override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.defineHeightForRow()

        var diagram = NSLocalizedString("Diagram", comment: "Part of the Title from DiagramView")
        
        self.title = "\(self.currentMeasurement.name) \(diagram)"
        
        self.tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        
        self.lineChart = LineChart()
        
        self.lineChartLabel.removeConstraints(lineChartLabel.constraints())
        self.lineChartLabel.setTranslatesAutoresizingMaskIntoConstraints(true)
        
        self.lineChart!.removeConstraints(lineChart!.constraints())
        self.lineChart!.setTranslatesAutoresizingMaskIntoConstraints(true)
        
        self.createTextForDayTab()
    }
    
    //sets the dimension of the dayLabel, lineChartLabel and lineChart
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
        
        self.lineChart!.frame = CGRect(
            x: 20,
            y: 20,
            width: 280,
            height: 200)
    }
    
    //passes the current measurement forward to CreateValueTableViewController
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "goToCreateValue" {
            
            let navigationController = segue.destinationViewController as UINavigationController
            let createValueTableViewController = navigationController.topViewController as CreateValueTableViewController
            
            createValueTableViewController.measurementToCreate = self.currentMeasurement
        
        }
    }
    
    /**
    * Line chart delegate method.
    */
    //will be executed if the user taps on a data point within the line chart
    func didSelectDataPoint(x: CGFloat, yValues: Array<CGFloat>) {
        
        var yAxisDescription = NSLocalizedString("Value", comment: "Description of Y Axis in LineChart")
        var xAxisDescription = String(NSLocalizedString("Month", comment: "Description of X Axis in LineChart"))
        
        if self.limit != 365 {
            
            xAxisDescription = NSLocalizedString("Day", comment: "Description of X Axis in LineChart")
            
        }
        
        self.lineChartLabel.text = "\(xAxisDescription): \(x)   \(yAxisDescription): \(yValues)"
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
    
    func addDataLineToChart(){
        
        var currentDate = self.date.getCurrentDateAsString()
        
        var parameters: Dictionary<String, AnyObject> = [
            
            "measurement"   : "\(self.currentMeasurement.nameInDatabase)",
            "userId"        : "\(self.userId)",
            "limit"         : "\(self.limit)",
            "endDate"       : "\(currentDate)",
            "company"       : "\(self.currentMeasurement.favoriteCompany)"
        ]

        Alamofire.request(.GET, "\(baseURL)/value/select", parameters: parameters)
            .responseSwiftyJSON { (request, response, json, error) in
                
                println(json)
                
                var data: Array<CGFloat> = []
                
                for (var i = 0; i < json.count; i++) {
                    
                    var value = CGFloat(json[i]["value"].intValue)
                    data.append(value)
                    
                }
                
                var dataReversed = data.reverse()
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    self.lineChart!.addLine(dataReversed)
                    
                }
        }

    }
    
    //this method gets the value for the day tag in the segmented bar
    func createTextForDayTab() {

        var currentDate = self.date.getCurrentDateAsString()
        
        var parameters: Dictionary<String, AnyObject> = [
            
            "measurement"   : "\(self.currentMeasurement.nameInDatabase)",
            "userId"        : "\(self.userId)",
            "limit"         : "\(self.limit)",
            "endDate"       : "\(currentDate)",
            "company"       : "\(self.currentMeasurement.favoriteCompany)"
        ]
        
        Alamofire.request(.GET, "\(baseURL)/value/select", parameters: parameters)
            .responseSwiftyJSON { (request, response, json, error) in
                
                println(request)
                
                println(json)
                
                var value = json[0]["value"].doubleValue
                var unit = json[0]["unit"].stringValue
                var date = json[0]["date"].stringValue
                var onWord = NSLocalizedString("on", comment: "word within the text if user clicked on day segment")
                
                var text = "\(value) \(unit) \(onWord) \(date)"
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    self.dayLabel.text = text
                    
                }
        }
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



