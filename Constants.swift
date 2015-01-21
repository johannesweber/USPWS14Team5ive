//
//  Appearance.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 05.12.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import Foundation
import UIKit

//NSUserDefaults stores userid, user email and wether user is logged in or not.
public let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()

//Focused Health Design Color
public let FHBlueColor = UIColor(red: 65/255, green: 192/255, blue: 194/255, alpha: 1)
public let FHGreyColor = UIColor(red: 222/255, green: 222/255, blue: 222/255, alpha: 1)
public let FHBrownColor = UIColor(red: 83/255, green: 71/255, blue: 65/255, alpha: 1)
public let FHLogoBlueColor = UIColor(red: 0/255, green: 138/255, blue: 255/255, alpha: 1)
public let FHBackgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)

//default PNChart Color
public let PNGreenColor = UIColor(red: 77.0 / 255.0 , green: 196.0 / 255.0, blue: 122.0 / 255.0, alpha: 1)
public let PNGreyColor = UIColor(red: 186.0 / 255.0 , green: 186.0 / 255.0, blue: 186.0 / 255.0, alpha: 1)
public let PNLightGreyColor = UIColor(red: 246.0 / 255.0 , green: 246.0 / 255.0, blue: 246.0 / 255.0, alpha: 1)

//Focused Health Server base Url
public let baseURL = "https://anakin.informatik.hs-mannheim.de/uip1/~johannes/focusedhealth"

//default Colors for Checkamrks in SetFavoriteCompanyViewController **unused**
public let WithingsColor = UIColor(red: 237.0 / 255.0 , green: 59.0 / 255.0, blue: 123.0 / 255.0, alpha: 1)
public let FitbitColor = UIColor(red: 50.0 / 255.0 , green: 50.0 / 255.0, blue: 50.0 / 255.0, alpha: 1)
public let FocusedHealthColor = UIColor(red: 246.0 / 255.0 , green: 246.0 / 255.0, blue: 246.0 / 255.0, alpha: 1)
public let MedisanaColor = UIColor(red: 0.0 / 255.0 , green: 121.0 / 255.0, blue: 68.0 / 255.0, alpha: 1)

//oauth consumer key and secret for each company supported
public let MedisanaKey =

[
    "consumerKey": "K98ZeXLehlgJDXxdA22Ygp5ix8GPiBczjiabohrA5kBCrcVZeErb42MpTvTT1ZpD",
    "consumerSecret": "LLwnjU3LMtSzdLDfm11imRkja12sY1SF7S5M7tiCL0yaaeEkyiGMEojXqCojE0Sh"
]

public let WithingsKey =
[
    "consumerKey": "0b1de1b1e2473372f5e8e30d0f13e38f9b20c84320cf8243517e73c0c084",
    "consumerSecret": "cdb631b4102893076d6feb038fd5fe7fd28431b998881d5c001307cece802"
]

public let FitbitKey = [
    
    "consumerKey"       : "7c39abf127964bc984aba4020845ff11",
    "consumerSecret"    : "18c4a92f21f1458e8ac9798567d3d38c"
]


