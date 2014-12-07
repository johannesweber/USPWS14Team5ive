//
//  DashboardViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 27.11.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit

import AlamoFire

class DashboardViewController: UIViewController, PNChartDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.buildLineChart()

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
    
    
    func buildLineChart(){
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "Y-m-d"
        
        Alamofire.request(.GET, "http://141.19.142.45/~johannes/focusedhealth/fitbit/time_series/water/")
            .responseSwiftyJSON { (request, response, json, error) in
                
                var xLabels = [String]()
                var values = [CGFloat]()
                
                for (var i = 0; i < json.count; i++){
                    var date = json[i]["date"].string!
                    var weekday = getDayOfWeek(date)
                    xLabels.append(weekday!)
                    
                    var value = CGFloat(json[i]["value"].intValue)
                    values.append(value)
                }
                
                var ChartLabel:UILabel = UILabel(frame: CGRectMake(0, 90, 320.0, 30))
                
                ChartLabel.textColor = FHBrownColor
                ChartLabel.textAlignment = NSTextAlignment.Center
                
                //Add LineChart
                ChartLabel.text = "Water"
                
                var lineChart:PNLineChart = PNLineChart(frame: CGRectMake(0, 135.0, 320, 200.0))
                lineChart.yLabelFormat = "%1"
                lineChart.showLabel = true
                lineChart.backgroundColor = UIColor.clearColor()
                lineChart.xLabels = xLabels
                lineChart.showCoordinateAxis = true
                lineChart.delegate = self
                
                // Line Chart Nr.1
                var data01Array: [CGFloat] = values
                var data01:PNLineChartData = PNLineChartData()
                data01.color = PNGreenColor
                data01.itemCount = data01Array.count
                data01.inflexionPointStyle = PNLineChartData.PNLineChartPointStyle.PNLineChartPointStyleCycle
                data01.getData = ({(index: Int) -> PNLineChartDataItem in
                    var yValue:CGFloat = data01Array[index]
                    var item = PNLineChartDataItem()
                    item.y = yValue
                    return item
                })
                
                lineChart.chartData = [data01]
                lineChart.strokeChart()
                
                self.view.addSubview(lineChart)
                self.view.addSubview(ChartLabel)
                
        }
    }
}