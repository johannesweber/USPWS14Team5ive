//
//  OAuthSwiftClient.swift
//  OAuthSwift
//
//  Created by Dongri Jin on 6/21/14.
//  Copyright (c) 2014 Dongri Jin. All rights reserved.
//

import Foundation
import Accounts

var dataEncoding: NSStringEncoding = NSUTF8StringEncoding

class OAuthSwiftClient {
    
    struct OAuth {
        static let version = "1.0"
        static let signatureMethod = "HMAC-SHA1"
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
        request.headers = ["Authorization": OAuthSwiftClient.authorizationHeaderForMethod(method, url: url!, parameters: parameters, credential: self.credential)]
        
        request.successHandler = success
        request.failureHandler = failure
        request.dataEncoding = dataEncoding
        
        request.start()
    }
    //get methode für withings selber erstellt
    func getFromWithings(urlString: String, parameters: Dictionary<String, AnyObject>, success: OAuthSwiftHTTPRequest.SuccessHandler?, failure: OAuthSwiftHTTPRequest.FailureHandler?) {
        
        let url = NSURL(string: urlString)
        
        let method = "GET"
        
        let request = OAuthSwiftHTTPRequest(URL: url!, method: method, parameters: parameters)
        
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
        
        request.headers = ["Authorization": OAuthSwiftClient.authorizationHeaderForMethod(method, url: url!, parameters: localParameters, credential: self.credential)]
        
        request.successHandler = success
        request.failureHandler = failure
        request.dataEncoding = dataEncoding
        
        request.encodeParameters = true
        
        request.start()
    }
    
    class func authorizationHeaderForMethod(method: String, url: NSURL, parameters: Dictionary<String, AnyObject>, credential: OAuthSwiftCredential) -> String {
        var authorizationParameters = Dictionary<String, AnyObject>()
        authorizationParameters["oauth_version"] = OAuth.version
        authorizationParameters["oauth_signature_method"] =  OAuth.signatureMethod
        authorizationParameters["oauth_consumer_key"] = credential.consumer_key
        authorizationParameters["oauth_timestamp"] = String(Int64(NSDate().timeIntervalSince1970))
        authorizationParameters["oauth_nonce"] = NSUUID().UUIDString as NSString
        
        if (credential.oauth_token != ""){
            authorizationParameters["oauth_token"] = credential.oauth_token
        }
        
        for (key, value: AnyObject) in parameters {
            if key.hasPrefix("oauth_") {
                authorizationParameters.updateValue(value, forKey: key)
            }
        }
        
        println(parameters)
        
        let combinedParameters = authorizationParameters.join(parameters)
        
        let finalParameters = combinedParameters
        
        authorizationParameters["oauth_signature"] = self.oauthSignatureForMethod(method, url: url, parameters: finalParameters, credential: credential)
        
        for param in authorizationParameters {
            println("Parameter: \(param)")
        }

        
        var authorizationParameterComponents = authorizationParameters.urlEncodedQueryStringWithEncoding(dataEncoding).componentsSeparatedByString("&") as [String]
        authorizationParameterComponents.sort { $0 < $1 }
        
        var headerComponents = [String]()
        for component in authorizationParameterComponents {
            let subcomponent = component.componentsSeparatedByString("=") as [String]
            if subcomponent.count == 2 {
                headerComponents.append("\(subcomponent[0])=\"\(subcomponent[1])\"")
            }
        }
        
        return "OAuth " + ", ".join(headerComponents)
    }
    
    class func oauthSignatureForMethod(method: String, url: NSURL, parameters: Dictionary<String, AnyObject>, credential: OAuthSwiftCredential) -> String {
        var tokenSecret: NSString = ""
        tokenSecret = credential.oauth_token_secret.urlEncodedStringWithEncoding(dataEncoding)
        
        println("tokenSecret: \(tokenSecret)")
        
        let encodedConsumerSecret = credential.consumer_secret.urlEncodedStringWithEncoding(dataEncoding)
        
        println("encodedConsumerSecret: \(encodedConsumerSecret)")
        
        let signingKey = "\(encodedConsumerSecret)&\(tokenSecret)"
        let signingKeyData = signingKey.dataUsingEncoding(dataEncoding)
        
        println("signingKey: \(signingKey)")
        println("signingKeyData: \(signingKeyData)")
        
        var parameterComponents = parameters.urlEncodedQueryStringWithEncoding(dataEncoding).componentsSeparatedByString("&") as [String]
        println("parameterComponents: \(parameterComponents)")
        
        parameterComponents.sort { $0 < $1 }
        println("parameterComponents sortiert: \(parameterComponents)")
        
        let parameterString = "&".join(parameterComponents)
        let encodedParameterString = parameterString.urlEncodedStringWithEncoding(dataEncoding)
        
        println("parameterString: \(parameterString)")
        println("encodedParameterString: \(encodedParameterString)")
        
        let encodedURL = url.absoluteString!.urlEncodedStringWithEncoding(dataEncoding)
        
        println("URL: \(url)")
        println("encodedURL: \(encodedURL)")
        
        let signatureBaseString = "\(method)&\(encodedURL)&\(encodedParameterString)"
        let signatureBaseStringData = signatureBaseString.dataUsingEncoding(dataEncoding)
        
        println("signatureBaseString: \(signatureBaseString)")
        println("signatureBaseStringData: \(signatureBaseStringData)")
        var a = signatureBaseString.digest(HMACAlgorithm.SHA1, key: signingKey)
        
        println("A: \(a)")

        let utf8str = a.dataUsingEncoding(NSUTF8StringEncoding)
        
        println("utf8 \(utf8str)")

        let base64Encoded = utf8str!.base64EncodedStringWithOptions(nil)

        //hier klemmt es irgendwie deswegen funktioniert withings nicht (hoffentlich)
        let signature = HMACSHA1Signature.signatureForKey(signingKeyData, data: signatureBaseStringData).base64EncodedStringWithOptions(nil)
        
        println("base64: \(base64Encoded)")
        println("signature: \(signature)")
        
        return signature
    }
}
