//
//  OAuthSwiftClient_Vitadock.swift
//  USPWS14Team5ive
//
//  Created by Christian Dorn on 27/11/14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import Foundation
import Accounts

class OAuthSwiftClient_Vitadock {
    
    struct OAuth_Vitadock {
        static let version = "1.0"
        static let signatureMethod = "HMAC-SHA256"
    }
    
    var credential: OAuthSwiftCredential
    
    init(consumerKey: String, consumerSecret: String) {
        self.credential = OAuthSwiftCredential(consumer_key: consumerKey, consumer_secret: consumerSecret)
    }
    
    init(consumerKey: String, consumerSecret: String, accessToken: String, accessTokenSecret: String) {
        self.credential = OAuthSwiftCredential(oauth_token: accessToken, oauth_token_secret: accessTokenSecret)
        self.credential.consumer_key = consumerKey
        self.credential.consumer_secret = consumerSecret
        
    }
    
    func get(urlString: String, parameters: Dictionary<String, AnyObject>, success: OAuthSwiftHTTPRequest.SuccessHandler?, failure: OAuthSwiftHTTPRequest.FailureHandler?) {
        
        let url = NSURL(string: urlString)
        
        let method = "GET"
        
        let request = OAuthSwiftHTTPRequest(URL: url!, method: method, parameters: parameters)
        request.headers = ["Authorization": OAuthSwiftClient_Vitadock.authorizationHeaderForMethod(method, url: url!, parameters: parameters, credential: self.credential)]
        
        request.successHandler = success
        request.failureHandler = failure
        request.dataEncoding = dataEncoding
        
        request.start()
    }
    
    func post(urlString: String, parameters: Dictionary<String, AnyObject>, success: OAuthSwiftHTTPRequest.SuccessHandler?, failure: OAuthSwiftHTTPRequest.FailureHandler?) {
        let url = NSURL(string: urlString)
        
        let method = "POST"
        
        var localParameters = parameters
        
        let request = OAuthSwiftHTTPRequest(URL: url!, method: method, parameters: localParameters)
        
        request.headers = ["Authorization": OAuthSwiftClient_Vitadock.authorizationHeaderForMethod(method, url: url!, parameters: localParameters, credential: self.credential)]
        
        request.successHandler = success
        request.failureHandler = failure
        request.dataEncoding = dataEncoding
        
        request.encodeParameters = true
        
        request.start()
    }
    
    class func authorizationHeaderForMethod(method: String, url: NSURL, parameters: Dictionary<String, AnyObject>, credential: OAuthSwiftCredential) -> String {
        var authorizationParameters = Dictionary<String, AnyObject>()
        authorizationParameters["oauth_version"] = OAuth_Vitadock.version
        authorizationParameters["oauth_signature_method"] =  OAuth_Vitadock.signatureMethod
        authorizationParameters["oauth_consumer_key"] = credential.consumer_key
        authorizationParameters["oauth_timestamp"] = String(Int64(NSDate().timeIntervalSince1970))
        authorizationParameters["oauth_nonce"] = NSUUID().UUIDString as NSString
        
        credential.oauth_timestamp = authorizationParameters["oauth_timestamp"] as String
        credential.oauth_nonce = authorizationParameters["oauth_nonce"] as String

        if (credential.oauth_token != ""){
            authorizationParameters["oauth_token"] = credential.oauth_token
        }
        
        for (key, value: AnyObject) in parameters {
            if key.hasPrefix("oauth_") {
                authorizationParameters.updateValue(value, forKey: key)
            }
        }
        
        let combinedParameters = authorizationParameters.join(parameters)
        
        let finalParameters = combinedParameters
        
        var signatureForHeader = self.oauthSignatureForMethod(method, url: url, parameters: finalParameters, credential: credential)
            .stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())!
            .stringByReplacingOccurrencesOfString("+", withString: "%2B", options: NSStringCompareOptions.LiteralSearch, range: nil)
            .stringByReplacingOccurrencesOfString("=", withString: "%3D", options: NSStringCompareOptions.LiteralSearch, range: nil)
            .stringByReplacingOccurrencesOfString("/", withString: "%2F", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        credential.oauth_signature = signatureForHeader
        
        var oauthHeader = String()
        var oauth_verifier = String()
        
        if(credential.oauth_verifier != ""){
            authorizationParameters["oauth_verifier"] = credential.oauth_verifier
            
            oauth_verifier = authorizationParameters["oauth_verifier"] as String
        }
        
        var oauth_consumer_key = authorizationParameters["oauth_consumer_key"] as String
        
        var oauth_signature_method = authorizationParameters["oauth_signature_method"] as String
        
        var oauth_timestamp = authorizationParameters["oauth_timestamp"] as String

        var oauth_nonce = authorizationParameters["oauth_nonce"] as String
        
        var oauth_token = String()
        
        if (credential.oauth_token != ""){
             oauth_token = authorizationParameters["oauth_token"] as String
        }

        var oauth_version = authorizationParameters["oauth_version"] as String
        
        if (oauth_token != ""){
            if(oauth_verifier != ""){
                oauthHeader = "OAuth oauth_consumer_key=" + oauth_consumer_key + ",oauth_signature_method=" + oauth_signature_method + ",oauth_timestamp=" + oauth_timestamp + ",oauth_nonce=" + oauth_nonce + ",oauth_token=" + oauth_token + ",oauth_verifier=" + oauth_verifier + ",oauth_version=" + oauth_version + ",oauth_signature=" + signatureForHeader
                
            }else{
                oauthHeader = "OAuth oauth_consumer_key=" + oauth_consumer_key + ",oauth_signature_method=" + oauth_signature_method + ",oauth_timestamp=" + oauth_timestamp + ",oauth_nonce=" + oauth_nonce + ",oauth_token=" + oauth_token + ",oauth_version=" + oauth_version + ",oauth_signature=" + signatureForHeader
            }
         
        
        }else{
            oauthHeader = "OAuth oauth_consumer_key=" + oauth_consumer_key + ",oauth_signature_method=" + oauth_signature_method + ",oauth_timestamp=" + oauth_timestamp + ",oauth_nonce=" + oauth_nonce + ",oauth_version=" + oauth_version + ",oauth_signature=" + signatureForHeader
        }
        
        return oauthHeader
    }
    
    class func oauthSignatureForMethod(method: String, url: NSURL, parameters: Dictionary<String, AnyObject>, credential: OAuthSwiftCredential) -> String {
        var tokenSecret: NSString = ""
        tokenSecret = credential.oauth_token_secret.urlEncodedStringWithEncoding(dataEncoding)
        
        let encodedConsumerSecret = credential.consumer_secret.urlEncodedStringWithEncoding(dataEncoding)
        
        let signingKey = "\(encodedConsumerSecret)&\(tokenSecret)"
        
        var parameterComponents = parameters.urlEncodedQueryStringWithEncoding(dataEncoding).componentsSeparatedByString("&") as [String]
        
        parameterComponents.sort { $0 < $1 }
        
        let parameterString = "&".join(parameterComponents)
        let encodedParameterString = parameterString.urlEncodedStringWithEncoding(dataEncoding)
        
        
        let encodedURL = url.absoluteString!.urlEncodedStringWithEncoding(dataEncoding)
        
        let signatureBaseString = "\(method)&\(encodedURL)&\(encodedParameterString)"

        let signature = signatureBaseString.digest(HMACAlgorithm.SHA256, key: signingKey).base64EncodedStringWithOptions(nil)
        return signature
    }
}

