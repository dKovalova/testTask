//
//  LoginScreen.swift
//  LoginScreen
//
//  Created by Diana on 12.07.2024.
//  Copyright © 2024 Cultured Code. All rights reserved.
//

import XCTest

class LoginScreen: BaseTestCase {
    
    var checklistpoint: XCUIElement!
    var loggingin: XCUIElement!
    var toolbar: XCUIElement!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        
        continueAfterFailure = false
        
        loggingin = app.staticTexts["Logging in..."]
        checklistpoint = app.staticTexts["Buy milk"]
        toolbar = app.toolbars["Toolbar"]
        
        
        // add checking if user is logged in = logout it
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.logout(confirm: true)
        
    }
    
    
    // to add case with Sign in error + Retry or Cancel
    // working test
    
    func testSuccessfulLogin() throws {
        
        
        // add func - runActivity("Enter email and password")
        
        self.fillEmailField(email: "test@example.com")
        app.keyboards.buttons["Return"].tap()
        
        self.fillPasswordField(password: "wA!@#$%^&*(_+=[}|':,>?/`~")
        app.keyboards.buttons["Return"].tap()
        
        let doneButton = app.buttons["login-button"]
        self.checkElementExists(elements: [doneButton], timeout: 1)
        app.buttons["login-button"].tap()
        
        
        // Check that the "Logging in..." message appears
        self.checkElementExists(elements: [loggingin], timeout: 1)
        
        //fix this func
        // Check if there's an error alert
           if errorLoginAlertIs() {
               // Retry login if there's an error alert
               retryLogin(confirm: true)
           }
        
        // Check that the "Checklist" screen appears
        self.checkElementExists(elements: [checklistpoint, logoutButton, toolbar], timeout: 5)
        
    }
    
    
    
    
    
    
    
    
}
