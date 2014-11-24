// Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

            let parameters :Dictionary = [
                "action"              : "(getmeas)",
                "user_id"             : "(user_id)",
                "consumer_key"        : "(consumer_key)",
                "nonce"               : "(oauth_nonce)",
                "signature"           : "(signatureWithings)",
                "signature_method"    : "HMAC-SHA1",
                "timestamp"           : "(credential.oauth_timestamp)",
                "token"               : "(credential.oauth_token)",
                "version"             : "1.0"
            ]

for params in parameters {
    println("Parameter \(params)")
}
