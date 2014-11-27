// Playground - noun: a place where people can play

import Cocoa

var text : String = "<>/"

var signature = text
    .stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
//    .stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())!
    .stringByReplacingOccurrencesOfString("+", withString: "%2B", options: NSStringCompareOptions.LiteralSearch, range: nil)
    .stringByReplacingOccurrencesOfString("=", withString: "%3D", options: NSStringCompareOptions.LiteralSearch, range: nil)