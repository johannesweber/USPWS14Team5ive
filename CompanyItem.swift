//
//  CompanyItem.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 06.01.15.
//  Copyright (c) 2015 Team 5ive. All rights reserved.
//

import Foundation
import UIKit


class CompanyItem: TableItem {

    //variables
    var color: UIColor
    var measurements: [MeasurementItem]
    
    //initialzer
    required init () {
        
        self.color = UIColor()
        self.measurements = [MeasurementItem]()
        
        super.init()
    }
    
    required convenience init(name: String, nameInDatabase: String) {
        self.init()
        
        self.name = name
        self.nameInDatabase = nameInDatabase
        
        self.color = self.createColor()
        self.populateMeasurementsArray(self.name)
        
    }
    
    func createColor() -> UIColor{
        
        var color =  UIColor()
        switch self.name {
            case "Fitbit":
            color = FitbitColor
            case "Withings":
            color = WithingsColor
            case "Medisana":
            color = MedisanaColor
            case "Focused Health":
            color = FocusedHealthColor
        default:
            println("Company not found")
        }
        
        return color
    }
    
    func populateMeasurementsArray(nameOfCompany: String) {
        
        switch name {
            case "Fitbit": self.createFitbitMeasurements()
            case "Withings": self.createWithingsMeasurements()
            case "Medisana": self.createMedisanaMeasurements()
        default: println("company not known")
        }
        
    }
    
    func createFitbitMeasurements() {
        
        var steps = MeasurementItem(name: NSLocalizedString("Steps", comment: "Name for Measurement Item Steps"), nameInDatabase: "steps", group: "Fitness")
        
        var duration = MeasurementItem(name: NSLocalizedString("Duration", comment: "Name for Measurement Item Duration"), nameInDatabase: "duration", group: "Fitness")
        
        var distance = MeasurementItem(name: NSLocalizedString("Distance", comment: "Name for Measurement Item Distance"), nameInDatabase: "distance", group: "Fitness")
        
        var caloriesBurned = MeasurementItem(name: NSLocalizedString("Calories Burned", comment: "Name for Measurement Item Calories Burned"), nameInDatabase: "caloriesOut", group: "Fitness")
        
        var elevation = MeasurementItem(name: NSLocalizedString("Elevation", comment: "Name for Measurement Item Elevation"), nameInDatabase: "elevation", group: "Fitness")
        
        var floors = MeasurementItem(name: NSLocalizedString("Floors", comment: "Name for Measurement Item Floors"), nameInDatabase: "floors", group: "Fitness")
        
        var bodyWeight = MeasurementItem(name: NSLocalizedString("Body Weight", comment: "Name for Measurement Item Body Weight"), nameInDatabase: "weight", group: "Vitals")
        
        var bodyHeight = MeasurementItem(name: NSLocalizedString("Body Height", comment: "Name for Measurement Item Body Height"), nameInDatabase: "height", group: "Vitals")
        
        var bmi = MeasurementItem(name: NSLocalizedString("BMI", comment: "Name for Measurement Item BMI"), nameInDatabase: "bmi", group: "Vitals")
        
        var bodyFat = MeasurementItem(name: NSLocalizedString("Body Fat", comment: "Name for Measurement Item Body Fat"), nameInDatabase: "bodyFat", group: "Vitals")
        
        var food = MeasurementItem(name: NSLocalizedString("Food", comment: "Name for Measurement Item Food"), nameInDatabase: "food", group: "Nutrition")
        
        var water = MeasurementItem(name: NSLocalizedString("Water", comment: "Name for Measurement Item Water"), nameInDatabase: "water", group: "Nutrition")
        
        var caloriesEaten = MeasurementItem(name: NSLocalizedString("Calories Eaten", comment: "Name for Measurement Item Calories Eaten"), nameInDatabase: "caloriesIn", group: "Nutrition")
        
        //TODO What to display in group sleep
        var sleepAnalysis = MeasurementItem(name: NSLocalizedString("Sleep Analysis", comment: "Name for Measurement Item Sleep Analysis"), nameInDatabase: "sleep", group: "Sleep")
        
        
        measurements.append(steps)
        
        measurements.append(duration)
        
        measurements.append(distance)
        
        measurements.append(caloriesBurned)
        
        measurements.append(elevation)
        
        measurements.append(floors)
        
        measurements.append(bodyWeight)
        
        measurements.append(bodyHeight)
        
        measurements.append(bmi)
        
        measurements.append(bodyFat)
        
        measurements.append(food)
        
        measurements.append(water)
        
        measurements.append(caloriesEaten)
        
    }
    
    func createWithingsMeasurements() {
        
    }
    
    func createMedisanaMeasurements() {
        
    }
    
}