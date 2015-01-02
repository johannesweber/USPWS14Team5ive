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

class DiagramViewController: UIViewController, LineChartDelegate, FitnessViewControllerDelegate {

    //variables
    var label: UILabel
    var lineChart: LineChart?
    var userId: Int
    var limit: Int
    var currentMeasurement: TableItem
    var currentDate: String
    
    required init(coder aDecoder: NSCoder) {
        
        self.lineChart = LineChart()
        self.label = UILabel()
        self.userId = prefs.integerForKey("USERID") as Int
        self.limit = 7
        self.currentMeasurement = TableItem()
        var date = Date()
        self.currentDate = date.getCurrentDateAsString()
        
        super.init(coder: aDecoder)
    }
    
    //IBOutlets
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    //IBAction
    @IBAction func segmentChanged(sender: UISegmentedControl) {
        
        self.limit = self.convertClickedSegmentIntoLimit(sender.selectedSegmentIndex)
        
        self.lineChart!.clear()
        
        self.addDataToLineChart()
    }
    
    @IBAction func add(sender: UIBarButtonItem) {
        
    }
    
    //override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.label.removeConstraints(label.constraints())
        self.label.setTranslatesAutoresizingMaskIntoConstraints(true)
        
        self.lineChart!.removeConstraints(lineChart!.constraints())
        self.lineChart!.setTranslatesAutoresizingMaskIntoConstraints(true)
                    
        self.buildDiagram()
        
        self.title = self.currentMeasurement.name
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.label.frame = CGRect(
            x: 0,
            y: 130,
            width: 320.0,
            height: 30)
        
        self.lineChart?.frame = CGRect(
            x: 20,
            y: 160,
            width: 280,
            height: 200)
    }
    
    /**
    * Line chart delegate method.
    */
    func didSelectDataPoint(x: CGFloat, yValues: Array<CGFloat>) {
        label.text = "x: \(x)     y: \(yValues)"
    }
    
    // fitness view controller delegate methods
    func fitnessViewController(controller: FitnessViewController, didSelectItem item: TableItem) {
        
        self.currentMeasurement = item
    }
    
    // methods
    func buildDiagram() {
        
        self.label.textAlignment = NSTextAlignment.Center
        self.view.addSubview(label)
        
        self.lineChart!.areaUnderLinesVisible = true
        self.lineChart!.labelsXVisible = false
        self.lineChart!.delegate = self
        self.lineChart!.axisInset = 30
        self.view.addSubview(lineChart!)
        
        self.addDataToLineChart()
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