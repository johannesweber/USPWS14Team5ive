//
//  HMAC.swift
//  USPWS14Team5ive
//
//  Created by Johannes Weber on 18.11.14.
//  Copyright (c) 2014 Johannes Weber. All rights reserved.
//

import Foundation

/*
*
*this class extends the String class with the function to hash a string with HMAC Algorithms
*
*/

enum HMACAlgorithm {
    case MD5, SHA1, SHA224, SHA256, SHA384, SHA512
    
    func toCCEnum() -> CCHmacAlgorithm {
        var result: Int = 0
        switch self {
        case .MD5:
            result = kCCHmacAlgMD5
        case .SHA1:
            result = kCCHmacAlgSHA1
        case .SHA224:
            result = kCCHmacAlgSHA224
        case .SHA256:
            result = kCCHmacAlgSHA256
        case .SHA384:
            result = kCCHmacAlgSHA384
        case .SHA512:
            result = kCCHmacAlgSHA512
        }
        return CCHmacAlgorithm(result)
    }
    
    func digestLength() -> Int {
        var result: CInt = 0
        switch self {
        case .MD5:
            result = CC_MD5_DIGEST_LENGTH
        case .SHA1:
            result = CC_SHA1_DIGEST_LENGTH
        case .SHA224:
            result = CC_SHA224_DIGEST_LENGTH
        case .SHA256:
            result = CC_SHA256_DIGEST_LENGTH
        case .SHA384:
            result = CC_SHA384_DIGEST_LENGTH
        case .SHA512:
            result = CC_SHA512_DIGEST_LENGTH
        }
        return Int(result)
    }
}

extension String {
    
    func digest(algorithm: HMACAlgorithm, key: String) -> NSData! {
        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let strLen = UInt(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestLen = algorithm.digestLength()
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
        let keyStr = key.cStringUsingEncoding(NSUTF8StringEncoding)
        let keyLen = UInt(key.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        
        CCHmac(algorithm.toCCEnum(), keyStr!, keyLen, str!, strLen, result)
        
        let data = NSData(bytes:result, length: digestLen)
        
        result.destroy()

        return data


    }
    
}