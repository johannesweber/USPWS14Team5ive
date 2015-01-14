//
//  StringOAuthSwiftTests.swift
//  USPWS14Team5ive
//
//  Created by Christian Dorn on 07/01/15.
//  Copyright (c) 2015 Team 5ive. All rights reserved.
//

import Foundation
import XCTest
import USPWS14Team5ive

// This class tests the regular expressions for emails and passwords for correctness
class StringOAuthSwiftTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testEmailIsValid(){
        var email = "chridorn93@gmail.com"
        XCTAssertTrue(email.isValidEmail(), "email is valid")
        
        email = "qwertz@gmx.co.uk"
        XCTAssertTrue(email.isValidEmail(), "Email is valid")
    }
    
    
    func testEmailIsInvalid_DomainIncorrect(){
        
        var email = "asdfasdfasdf.gmx.de"
        XCTAssertFalse(email.isValidEmail(), "@ Character is missing, therefor the email has no domain part")
        
        email = "asdf@asdf.asdfasdf"
        XCTAssertFalse(email.isValidEmail(), "country code has more than 4 characters")
        
        email = "asdf@asdf.a"
        XCTAssertFalse(email.isValidEmail(), "country code has less than 2 characters")
        
        email = "asdf@qwer"
        XCTAssertFalse(email.isValidEmail(), "Address has no country code")
        
        email = "asdf@"
        XCTAssertFalse(email.isValidEmail(), "Address has no domain part")
        
        email = "@"
        XCTAssertFalse(email.isValidEmail(), "Address has no local or domain part")
        
    }
    
    
    func testEmailIsInvalid_LocalPartIncorrect(){
        
        var email = "@gmx.de"
        XCTAssertFalse(email.isValidEmail(), "Address has no local part")
        
        email = "@"
        XCTAssertFalse(email.isValidEmail(), "Address has no local or domain part")
        
    }
    
    
    func testEmailIsInvalid_UseOfInvalidCharacters(){
        //email regex [A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}
        var email = "asdf!2w@gmx.ad"
        XCTAssertFalse(email.isValidEmail(), "Address has ! as a character")
        
        email = "asdf@gmx.d2"
        XCTAssertFalse(email.isValidEmail(), "No Numbers allowed in country code")
        
        email = "asdf@a+b.de"
        XCTAssertFalse(email.isValidEmail(), "No + allowed in domain part(compared to local part)")
        
        email = "asdf@a%b.de"
        XCTAssertFalse(email.isValidEmail(), "No % allowed in domain part(compared to local part)")
    }
    
    //password can only contain the following characters: A-Z, a-z, 0-9, ., _, %, +, - and has to
    // be between 6 and 18 characters long.
    func testPasswordIsValid(){
        var password = "y25eum333"
        XCTAssertTrue(password.isValidPassword(), "Password contains allowed characters only")
        
        password = "123456"
        XCTAssertTrue(password.isValidPassword(), "Password has minimum length")
        
        password = "112233445566778899"
        XCTAssertTrue(password.isValidPassword(), "Password has maximum length")
        
        password = "#+-_%.asd!"
        XCTAssertTrue(password.isValidPassword(), "Password contains allowed characters only")
        
    }
    
    
    func testPasswordIsInvalid_PasswordIsTooLong(){
        
        var password = "1111111111111111111"
        XCTAssertFalse(password.isValidPassword(), "Password is too long (19 characters, maximum is 18) ")
    }
    
    func testPasswordIsInvalid_PasswordIsTooShort(){
        var password = "12345"
        XCTAssertFalse(password.isValidPassword(), "Password is too short (5 Characters, minimum is 6)")
    }
    
    func testPasswordIsInvalid_UseOfInvalidCharacters(){
        var password = "*as25F#^!$§%&/()="
        XCTAssertFalse(password.isValidPassword(), "Password contains characters that are not allowed (*, ^)")
    }
    
}