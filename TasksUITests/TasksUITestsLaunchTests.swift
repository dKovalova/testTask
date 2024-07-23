//
//  TasksUITestsLaunchTests.swift
//  TasksUITests
//
//  Created by Diana on 12.07.2024.
//  Copyright © 2024 Cultured Code. All rights reserved.
//


// Tasks class doesnt work yet

import XCTest

class Tasks: BaseTestCase {
    
    //define the login screen elements in the Tasks class to use it in multiple tests
    var checklistpoint: XCUIElement!
    
    
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        // Initialize login screen elements
        checklistpoint = app.staticTexts["Buy milk"]
        
        self.logIn(email: "test@example.com", password: "1")
        
        // Check for login alert if it appears, otherwise continue
            //dont add this code in Login func because it causes error in testLoginWithInvalidEmail()
               if errorLoginAlertIs(timeout: 5) {
                   // Retry login if there's an error alert
                   retryLogin(confirm: true)
               }
        
       //Check that User is Logged in
        self.checkElementExists(elements: [checklistpoint], timeout: 3)
    
        
    }
    
    
    override func tearDownWithError() throws {
        // Log out the user if logged in
        if self.isUserLoggedIn() {
            self.logout(confirm: true)
        }
        try super.tearDownWithError()
    }
    
    
    
    func testConfirmLogout() {
        
        self.logout(confirm: true)
        
        
        // verification that Login screen appears
       self.checkElementExists(elements: [emailTextField, passwordTextField, loginButton], timeout: 10)
        
        
        // Restart the app
        app.terminate()
        app.launch()
        
        // Verify that the Login screen appears again after restarting the app
     self.checkElementExists(elements: [emailTextField, passwordTextField, loginButton], timeout: 10)
        
    }
    
    func testCancelLogout() {
        logout(confirm: false)
        
        //add verification that Tasks screen opened
        checkElementExists(elements: [checklistpoint], timeout: 3)
        
        //add restart app + checking screen
        
    }
    
    
    
    
//    func testAllButtonsAreHittable() {
//        let result = self.checkAllButtonsAreHittable()
//        XCTAssertTrue(result.allHittable, "One or more buttons are not hittable")
//        
//        if !result.allHittable {
//            let nonHittableButtons = result.nonHittableButtons.map { $0.label }
//            XCTFail("Buttons not hittable: \(nonHittableButtons)")
//        }
//    }
}
