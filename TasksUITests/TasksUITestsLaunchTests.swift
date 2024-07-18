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
        
        self.logIn()
        
      
    
        
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
        
        
        //add verification that Login screen appears
        self.checkElementExists(elements: [emailTextField, passwordTextField, loginButton], timeout: 3)
    }
    
    
    
    
    
    func testCancelLogout() {
        self.logout(confirm: false)
        
        //add verification that Tasks screen opened
        self.checkElementExists(elements: [checklistpoint], timeout: 3)
        
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
