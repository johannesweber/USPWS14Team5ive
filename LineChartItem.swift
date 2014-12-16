//
//  LineChartItem.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 15.12.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit
import Foundation

class LineChartItem: LineChartDelegate {
    
    //Variables
    var label: UILabel
    var lineChart: LineChart?
    
    
    //init
    init(labelText: String, values: Array<CGFloat>){
        
        self.label = UILabel(frame: CGRectMake(0, 90, 320.0, 30))
        self.lineChart = LineChart(frame: CGRectMake(0, 135.0, 320, 200.0))
        
        var valuesReversed = values.reverse()
        
        self.label.text = labelText
        self.label.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.label.textAlignment = NSTextAlignment.Center
        
        self.lineChart = LineChart()
        self.lineChart!.addLine(valuesReversed)
        self.lineChart!.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.lineChart!.delegate = self
        
    }
    
    //Methods
    func getLineChart() -> LineChart {
        
        return self.lineChart!
    }
    
    func getLabel() -> UILabel {
        
        return self.label
    }
    
    // LineChartDelegate Method.
    func didSelectDataPoint(x: CGFloat, yValues: Array<CGFloat>) {
        
        label.text = "x: \(x)     y: \(yValues)"
    }
}


