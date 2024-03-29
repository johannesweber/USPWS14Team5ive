//
//  NSURL+OAuthSwift.swift
//  OAuthSwift
//
//  Created by Dongri Jin on 6/21/14.
//  Copyright (c) 2014 Dongri Jin. All rights reserved.
//

import Foundation

/*
*
*this class extends the NSURL class with a function for appending a query string to a url.
*
*/


extension NSURL {

    func URLByAppendingQueryString(queryString: String) -> NSURL {
        if queryString.utf16Count == 0 {
            return self
        }

        var absoluteURLString = self.absoluteString!

        if absoluteURLString.hasSuffix("?") {
            absoluteURLString = (absoluteURLString as NSString).substringToIndex(absoluteURLString.utf16Count - 1)
        }

        let URLString = absoluteURLString + (absoluteURLString.rangeOfString("?") != nil ? "&" : "?") + queryString

        return NSURL(string: URLString)!
    }

}
