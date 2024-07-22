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
    var errorAlert: XCUIElement!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        
        continueAfterFailure = false
        
        loggingin = app.staticTexts["Logging in..."]
        checklistpoint = app.staticTexts["Buy milk"]
        toolbar = app.toolbars["Toolbar"]
        errorAlert = app.alerts["Error"]
        
        
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
        
        
        
        logIn(email: "test@example.com", password: "wA!@#$%^&*(_+=[}|':,>?/`~")
        
        // Check that the "Logging in..." message appears
        self.checkElementExists(elements: [loggingin], timeout: 1)
        
    
        //fix  errorLoginAlertIs
        // Check if there's an error alert
           if errorLoginAlertIs() {
               // Retry login if there's an error alert
               retryLogin(confirm: true)
           }
        
        // Check that the "Checklist" screen appears
        self.checkElementExists(elements: [checklistpoint, logoutButton, toolbar], timeout: 5)
        
    }
    
    
    
    
    //broken test
    //wrong alert found durins test execution
    func testLoginWithInvalidEmail() {
    
        logIn(email: "example.com", password: "123")
    
        
        //checking alert existance
        if incorrectLoginValuesAlertIs(expectedMessage: "Incorrect login or password format") {
            let okButton = app.buttons["Ok"]
                    if okButton.exists {
                        okButton.tap()
                    } else {
                        XCTFail("Ok button not found in error alert.")
                    }
                } else {
                    XCTFail("Error alert with the expected message not found.")
                }
        }
       
    
        
    func testLoginButtonAvailability () {
        
        
        //only email field is filled
        fillEmailField (email: "test")
        app.keyboards.buttons["Return"].tap()
        XCTAssertTrue(isButtonHittable(button: "login-button"), "Login button should not be hittable when only email is filled")
        
        
        // Clear email field
        clearTextInField(emailTextField)

        
        
        // only password field is filled
        fillPasswordField(password: "123")
        app.keyboards.buttons["Return"].tap()
        XCTAssertTrue(isButtonHittable(button: "login-button"), "Login button should not be hittable when only password is filled")
        
        // Clear password field
        clearTextInField(passwordTextField)
        
        
        // Both fields are filled
        fillEmailField(email: "test@example.com")
        fillPasswordField(password: "123")
        app.keyboards.buttons["Return"].tap()
        
        XCTAssertTrue(isButtonHittable(button: "login-button"), "Login button should be hittable when both fields are filled")

    }
        
    
        
    }
    
    
    
    
    
    
    
    

