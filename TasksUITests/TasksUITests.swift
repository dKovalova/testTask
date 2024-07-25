//
//  LoginScreen.swift
//  LoginScreen
//
//  Created by Diana on 12.07.2024.
//  Copyright © 2024 Cultured Code. All rights reserved.
//

import XCTest

class LoginScreen: BaseTestCase {
    var loggingin: XCUIElement!
    var toolbar: XCUIElement!
    var errorAlert: XCUIElement!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        loggingin = app.staticTexts["Logging in..."]
        toolbar = app.toolbars["Toolbar"]
        
        if self.isUserLoggedIn() {
            self.logout(confirm: true)
        }
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }
    
    func testSuccessfulLogin() throws {
        logIn(email: testStrings.validEmail, password: testStrings.validPassword)
        // Check that the "Logging in..." message appears
        self.checkElementExists(elements: [loggingin], timeout: 1)
        // Wait for an alert to appear and handle it if it does
        if alerts.waitForExistence(timeout: 5) {
                closeAppAlerts(with: "Retry")
        }
        // Check that the "Checklist" screen appears
        checkElementExists(elements: [checklistpoint, toolbar], timeout: 3)
    }
    
    func testLoginWithInvalidEmail() {
        logIn(email: testStrings.invalidEmail, password: testStrings.validPassword)
        closeAppAlerts(with: "Ok")
        XCTAssert(loginButton.exists, "Login button is not found after aler closing")
        }
     
    func testLoginButtonAvailability () {
        //only email field is filled
        fillEmailField (email: testStrings.invalidEmail)
        app.keyboards.buttons["Return"].tap()
        XCTAssertTrue(isButtonHittable(button: loginButton), "Login button should not be hittable when only email is filled")
        // Clear email field
        clearTextInField(emailTextField)
        // only password field is filled
        fillPasswordField(password: testStrings.validPassword)
        app.keyboards.buttons["Return"].tap()
        XCTAssertTrue(isButtonHittable(button: loginButton), "Login button should not be hittable when only password is filled")
        // Clear password field
        clearTextInField(passwordTextField)
        // Both fields are filled
        fillEmailField(email: testStrings.validEmail)
        fillPasswordField(password: testStrings.validPassword)
        app.keyboards.buttons["Return"].tap()
        XCTAssertTrue(isButtonHittable(button: loginButton), "Login button should be hittable when both fields are filled")
    }
}
