//
//  DashboardViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 27.11.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit

import AlamoFire

class DashboardViewController: UIViewController {
    
    //variables
    
    var userId = prefs.integerForKey("USERID") as Int
    var fitbit = Fitbit()
    
    //IBAction
    
    @IBAction func synchronize(sender: UIBarButtonItem) {
        
        fitbit.synchronizeData()
        self.buildLineChartSteps()
    }
    
    //methods
    
    func buildLineChartSteps(){
        
        println("\(userId)")
        
        let parameters: Dictionary<String, AnyObject> = [
            "endDate"   : "2014-12-16",
            "limit"     : "7",
            "userId"    : "\(userId)"
        ]
        
        //TODO create date object from string
        Alamofire.request(.GET, "http://141.19.142.45/~timon/focusedhealth/fitbit/time_series/steps/", parameters: parameters)
            .responseSwiftyJSON { (request, response, json, error) in
                
                println(json)
                
                var values = [CGFloat]()
                
                for (var i = 0; i < json.count; i++){
                
                    var value = CGFloat(json[i]["value"].intValue)
                    values.append(value)
                
                }
                
                var views: Dictionary<String, AnyObject> = [:]
                
                var lineChartSteps = LineChartItem(labelText: "Steps", values: values)
                
                views["label"] = lineChartSteps.getLabel()
                views["chart"] = lineChartSteps.getLineChart()
                
                self.view.addSubview(lineChartSteps.getLabel())
                self.view.addSubview(lineChartSteps.getLineChart())
                
                self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[label]-|", options: nil, metrics: nil, views: views))
                self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-80-[label]", options: nil, metrics: nil, views: views))

                self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[chart]-|", options: nil, metrics: nil, views: views))
                self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[label]-[chart(==200)]", options: nil, metrics: nil, views: views))
        }
    }
}