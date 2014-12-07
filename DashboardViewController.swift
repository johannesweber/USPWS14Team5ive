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

        var ChartLabel:UILabel = UILabel(frame: CGRectMake(0, 90, 320.0, 30))
        
        ChartLabel.textColor = PNGreenColor
        ChartLabel.font = UIFont(name: "Avenir-Medium", size:23.0)
        ChartLabel.textAlignment = NSTextAlignment.Center

            //Add LineChart
            ChartLabel.text = "Steps"
            
            var lineChart:PNLineChart = PNLineChart(frame: CGRectMake(0, 135.0, 320, 200.0))
            lineChart.yLabelFormat = "%1.1f"
            lineChart.showLabel = true
            lineChart.backgroundColor = UIColor.clearColor()
            lineChart.xLabels = ["SEP 1","SEP 2","SEP 3","SEP 4","SEP 5","SEP 6","SEP 7"]
            lineChart.showCoordinateAxis = true
            lineChart.delegate = self
            
            // Line Chart Nr.1
            var data01Array: [CGFloat] = [60.1, 160.1, 126.4, 262.2, 186.2, 127.2, 176.2]
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