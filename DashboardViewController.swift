//
//  DashboardViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 27.11.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit

import AlamoFire

class DashboardViewController: UIViewController, PNChartDelegate, LineChartDelegate {
    
    var label = UILabel()
    var lineChart: LineChart?
    
    var lineChartWater:PNLineChart = PNLineChart(frame: CGRectMake(0, 135, 320, 200.0))
    var ChartLabelWater:UILabel = UILabel(frame: CGRectMake(0, 90, 320.0, 30))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: Selector("downSwiped"))
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        self.view.addGestureRecognizer(swipeDown)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: Selector("upSwiped"))
        swipeUp.direction = UISwipeGestureRecognizerDirection.Up
        self.view.addGestureRecognizer(swipeUp)
        
    }
    
    func downSwiped(){
        
        if (!self.view.subviews.isEmpty) {
            
            self.lineChartWater.removeFromSuperview()
            self.ChartLabelWater.removeFromSuperview()
            
        } else {
            
            self.buildLineChartSteps()
            
        }
        
    }
    
    func upSwiped(){
        
        if (!self.view.subviews.isEmpty) {
            
            self.lineChart?.removeFromSuperview()
            self.label.removeFromSuperview()
            
        } else {
            
            self.buildLineChartWater()
        }
    }
    
    
    
    func userClickedOnLineKeyPoint(point: CGPoint, lineIndex: Int, keyPointIndex: Int)
    {
        println("Click Key on line \(point.x), \(point.y) line index is \(lineIndex) and point index is \(keyPointIndex)")
    }
    
    func userClickedOnLinePoint(point: CGPoint, lineIndex: Int)
    {
        println("Click Key on line \(point.x), \(point.y) line index is \(lineIndex)")
    }
    
    func userClickedOnBarCharIndex(barIndex: Int)
    {
        println("Click  on bar \(barIndex)")
    }
    
    
    func buildLineChartWater(){
        
        Alamofire.request(.GET, "http://141.19.142.45/~johannes/focusedhealth/fitbit/time_series/water/")
            .responseSwiftyJSON { (request, response, json, error) in
                
                var xLabels = [String]()
                var values = [CGFloat]()
                var valuesReversed = [CGFloat]()
                var xLabelsReversed = [String]()
                
                for (var i = 0; i < json.count; i++){
                    var date = json[i]["date"].string!
                    var weekday = getDayOfWeek(date)
                    xLabels.append(weekday!)
                    
                    xLabelsReversed = xLabels.reverse()
                    
                    var value = CGFloat(json[i]["value"].intValue)
                    values.append(value)
                    
                    valuesReversed = values.reverse()
                }
                
                self.ChartLabelWater.textColor = FHBrownColor
                self.ChartLabelWater.textAlignment = NSTextAlignment.Center
                
                //Add LineChart
                self.ChartLabelWater.text = "Water"
                
                self.lineChartWater.yLabelFormat = "%1"
                self.lineChartWater.showLabel = true
                self.lineChartWater.backgroundColor = UIColor.clearColor()
                self.lineChartWater.xLabels = xLabelsReversed
                self.lineChartWater.showCoordinateAxis = true
                self.lineChartWater.delegate = self
                
                // Line Chart Water
                var data01Array: [CGFloat] = valuesReversed
                var data01:PNLineChartData = PNLineChartData()
                data01.color = UIColor.orangeColor()
                data01.itemCount = data01Array.count
                data01.inflexionPointStyle = PNLineChartData.PNLineChartPointStyle.PNLineChartPointStyleCycle
                data01.getData = ({(index: Int) -> PNLineChartDataItem in
                    var yValue:CGFloat = data01Array[index]
                    var item = PNLineChartDataItem()
                    item.y = yValue
                    return item
                })
                
                self.lineChartWater.chartData = [data01]
                self.lineChartWater.strokeChart()
                
                self.view.addSubview(self.lineChartWater)
                self.view.addSubview(self.ChartLabelWater)
                
        }
    }
    
    func buildLineChartSteps(){
        
        Alamofire.request(.GET, "http://141.19.142.45/~johannes/focusedhealth/fitbit/time_series/steps/")
            .responseSwiftyJSON { (request, response, json, error) in
                
                var xLabels = [String]()
                var values = [CGFloat]()
                
                var valuesReversed = [CGFloat]()
                var xLabelsReversed = [String]()
                
                for (var i = 0; i < json.count; i++){
                    var date = json[i]["date"].string!
                    var weekday = getDayOfWeek(date)
                    xLabels.append(weekday!)
                    
                    xLabelsReversed = xLabels.reverse()
                    
                    var value = CGFloat(json[i]["value"].intValue)
                    values.append(value)
                    
                    valuesReversed = values.reverse()
                }

        
                var views: Dictionary<String, AnyObject> = [:]
        
                self.label.text = "Steps"
                self.label.setTranslatesAutoresizingMaskIntoConstraints(false)
                self.label.textAlignment = NSTextAlignment.Center
                self.view.addSubview(self.label)
                views["label"] = self.label
                self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[label]-|", options: nil, metrics: nil, views: views))
                self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-80-[label]", options: nil, metrics: nil, views: views))
        
                var data: Array<CGFloat> = valuesReversed
        
                self.lineChart = LineChart()
                self.lineChart!.dotsVisible = false
                self.lineChart!.gridVisible = false
                self.lineChart!.numberOfGridLinesX = 30
                self.lineChart!.numberOfGridLinesY = 10
                self.lineChart!.addLine(data)
                self.lineChart!.setTranslatesAutoresizingMaskIntoConstraints(false)
                self.lineChart!.delegate = self
                self.view.addSubview(self.lineChart!)
                views["chart"] = self.lineChart
                self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[chart]-|", options: nil, metrics: nil, views: views))
                self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[label]-[chart(==200)]", options: nil, metrics: nil, views: views))
                
        }
    }
    
    /**
    * Line chart delegate method.
    */
    func didSelectDataPoint(x: CGFloat, yValues: Array<CGFloat>) {
        label.text = "x: \(x)     y: \(yValues)"
    }
    
    /**
    * Redraw chart on device rotation.
    */
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        if let chart = lineChart {
            chart.setNeedsDisplay()
        }
    }
}