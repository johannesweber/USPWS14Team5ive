//
//  String+OAuthSwift.swift
//  OAuthSwift
//
//  Created by Dongri Jin on 6/21/14.
//  Copyright (c) 2014 Dongri Jin. All rights reserved.
//

import Foundation

/*
*
*this class extends the String class with certain functions used in the oauth process.
*
*/

extension String {
    
    func urlEncodedStringWithEncoding(encoding: NSStringEncoding) -> String {
        let charactersToBeEscaped = ":/?&=;+!@#$()',*" as CFStringRef
        let charactersToLeaveUnescaped = "[]." as CFStringRef

        var raw: NSString = self
        
        let result = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, raw, charactersToLeaveUnescaped, charactersToBeEscaped, CFStringConvertNSStringEncodingToEncoding(encoding)) as NSString

        return result
    }

    func parametersFromQueryString() -> Dictionary<String, String> {
        var parameters = Dictionary<String, String>()

        let scanner = NSScanner(string: self)

        var key: NSString?
        var value: NSString?

        while !scanner.atEnd {
            key = nil
            scanner.scanUpToString("=", intoString: &key)
            scanner.scanString("=", intoString: nil)

            value = nil
            scanner.scanUpToString("&", intoString: &value)
            scanner.scanString("&", intoString: nil)

            if (key != nil && value != nil) {
                parameters.updateValue(value!, forKey: key!)
            }
        }
        
        return parameters
    }
    //分割字符
    func split(s:String)->[String]{
        if s.isEmpty{
            var x=[String]()
            for y in self{
                x.append(String(y))
            }
            return x
        }
        return self.componentsSeparatedByString(s)
    }
    //去掉左右空格
    func trim()->String{
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
    //是否包含字符串
    func has(s:String)->Bool{
        if (self.rangeOfString(s) != nil) {
            return true
        }else{
            return false
        }
    }
    //是否包含前缀
    func hasBegin(s:String)->Bool{
        if self.hasPrefix(s) {
            return true
        }else{
            return false
        }
    }
    //是否包含后缀
    func hasEnd(s:String)->Bool{
        if self.hasSuffix(s) {
            return true
        }else{
            return false
        }
    }
    //统计长度
    func length()->Int{
        return countElements(self)
    }
    //统计长度(别名)
    func size()->Int{
        return countElements(self)
    }
    //重复字符串
    func repeat(times: Int) -> String{
        var result = ""
        for i in 0..<times {
            result += self
        }
        return result
    }
    //反转
    func reverse()-> String{
        var s=self.split("").reverse()
        var x=""
        for y in s{
            x+=y
        }
        return x
    }
    
    //tests if a string is a valid e mail adress using regex
    //due to swift not supporting regular expressions yet, we decided
    //to use the method rangeOfString() and additional commands to
    //achieve the same functionality
    func isValidEmail() -> Bool {
        
        var result = true
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let range = self.rangeOfString(emailRegEx, options:.RegularExpressionSearch)
        
        let possibleRange = self.rangeOfString(emailRegEx, options: .RegularExpressionSearch)
        
        if possibleRange != nil{
            if let range = possibleRange {
                if distance(self.startIndex, range.startIndex) != 0{
                    result = false
                }
                if distance(self.startIndex, range.endIndex) != self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding){
                    result = false
                }
            }
        }else{
            result = false
        }
        
        return result
    }
    
    //tests if a password does match certain requirements
    func isValidPassword() -> Bool {
        var result = true
        let passwordRegEx = "[A-Za-z0-9._%+#!-]{6,18}"
        let possibleRange = self.rangeOfString(passwordRegEx, options: .RegularExpressionSearch)
        
        if self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 18 || self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) < 6 {
            result = false
        }
        if possibleRange != nil{
            if let range = possibleRange {
                if distance(self.startIndex, range.startIndex) != 0{
                    result = false
                }
                if distance(self.startIndex, range.endIndex) != self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding){
                    result = false
                }
            }
        }else{
            result = false
        }
        
        return result
    }
}

