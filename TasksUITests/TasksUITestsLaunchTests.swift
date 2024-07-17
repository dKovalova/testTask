//
//  TasksUITestsLaunchTests.swift
//  TasksUITests
//
//  Created by Diana on 12.07.2024.
//  Copyright © 2024 Cultured Code. All rights reserved.
//

import XCTest

class Tasks: BaseTestCase {
    
    
    
    
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        try super.setUpWithError()
        
        // Ensure the user is logged in before each test
        self.fillEmailField(email: "test@example.com")
        //self.tapReturnKey()
        self.fillPasswordField(password: "123")
        //     self.tapReturnKey()
        app.buttons["login-button"].tap()
        
        
        
        
    }
    
    override func tearDownWithError() throws {
        
    }
    
    func testConfirmLogout() {
        let app = XCUIApplication()
        app.launch()
        
        self.logout(confirm: true)
        //screen appears
        
    }
    
    
    
    
    
    func testCancelLogout() {
        let app = XCUIApplication()
        app.launch()
        
        
        self.logout(confirm: false)
        
        //screen appers
        
    }
    
    
    func testAllButtonsAreHittable() {
        let app = XCUIApplication()
        app.launch()
        
   //     XCTAssertTrue(self.checkAllButtonsAreHittable(), "One or more buttons are not hittable")
            }
    }

