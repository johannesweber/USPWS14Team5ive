//
//  FitnessDiagramViewController.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 01.12.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import UIKit
import QuartzCore

class FitnessDiagramViewController: UIViewController, LineChartDelegate {

    //variables
    var label: UILabel
    var lineChart: LineChart?
    
    required init(coder aDecoder: NSCoder) {
        self.lineChart = LineChart()
        self.label = UILabel()
        
        super.init(coder: aDecoder)
    }
    

    
    //IBOutlets
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    //IBAction
    @IBAction func segmentChanged(sender: AnyObject) {
        println("Segment changed: \(sender.selectedSegmentIndex)")
    }
    
    //override functions
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.label.removeConstraints(label.constraints())
        self.label.setTranslatesAutoresizingMaskIntoConstraints(true)
        
        self.lineChart!.removeConstraints(lineChart!.constraints())
        self.lineChart!.setTranslatesAutoresizingMaskIntoConstraints(true)
                    
        self.buildDiagram()
    }
    
    //functions
    func buildDiagram() {
            
        label.textAlignment = NSTextAlignment.Center
        self.view.addSubview(label)
            
        var data: Array<CGFloat> = [3, 4, 9, 11, 13, 15]
            
        lineChart!.areaUnderLinesVisible = true
        lineChart!.labelsXVisible = false
        lineChart!.addLine(data)
        lineChart!.delegate = self
        lineChart!.axisInset = 20
        self.view.addSubview(lineChart!)
    }
    
    /**
    * Line chart delegate method.
    */
    func didSelectDataPoint(x: CGFloat, yValues: Array<CGFloat>) {
        label.text = "x: \(x)     y: \(yValues)"
    }
}
