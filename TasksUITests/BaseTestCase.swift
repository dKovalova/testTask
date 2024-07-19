//
//  BaseTestCase.swift
//  TasksUITests
//
//  Created by Diana on 12.07.2024.
//  Copyright © 2024 Cultured Code. All rights reserved.
//

import Foundation
import XCTest

class BaseTestCase: XCTestCase {
    
    
    let app = XCUIApplication()
    
      var emailTextField: XCUIElement!
       var passwordTextField: XCUIElement!
       var logoutButton: XCUIElement!
       var loginButton: XCUIElement!
    
    
    override func setUpWithError() throws {
        // fix "app.launch()" usage in each func
        continueAfterFailure = false
        app.launch()
        
        
        // Initialize UI elements
                emailTextField = app.textFields["Email"]
                passwordTextField = app.secureTextFields["Password"]
                logoutButton = app.buttons["Logout"]
                loginButton = app.buttons["login-button"]
       
    }
    
    
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.

    }
    
    func checkElementExists(elements: [XCUIElement], timeout: TimeInterval) {
        for element in elements {
            let exists = element.waitForExistence(timeout: timeout)
            XCTAssertTrue(exists, "Element \(element) does not exist.")
        }
    }
      
    
    
        //for Tasks class (setUp))
    func logIn(email: String, password: String) {
        // Ensure the user is logged in before each test
        fillEmailField(email: email)
        app.keyboards.buttons["Return"].tap()
        //self.tapReturnKey() - func doesn't work yet
        fillPasswordField(password: password)
        //self.tapReturnKey() - func doesn't work yet
        app.keyboards.buttons["Return"].tap()
        app.buttons["login-button"].tap()
        
        if errorLoginAlertIs() {
            retryLogin(confirm: true)
        }
        
       checkElementExists(elements: [logoutButton], timeout: 5)
    }
        
    
    // Function to handle logout if logged in
    func logout(confirm: Bool) {
            if isUserLoggedIn() {
                logoutButton.tap()
                handleLogoutAlert(confirm: confirm)
            }
        }
    
    
    // Handle the logout confirmation alert
private  func handleLogoutAlert(confirm: Bool) {
        let alert = app.alerts.firstMatch
        let logoutButton = alert.buttons["Logout"]
        let cancelButton = alert.buttons["Cancel"]
        
        if logoutButton.waitForExistence(timeout: 2) {
            if confirm {
                logoutButton.tap()
            } else {
                cancelButton.tap()
            }
        } else {
            XCTFail("Logout confirmation alert did not appear.")
        }
    }
    
    
    
    //for tearnDown in tasks class
    //Check if the user is logged in
    func isUserLoggedIn() -> Bool {
        let tasksScreenElement = app.buttons["Logout"]
        return tasksScreenElement.exists
    }
    
        func fillEmailField(email: String) {
                    
                    checkElementExists(elements: [emailTextField], timeout: 1)
                    emailTextField.tap()
                    emailTextField.typeText(email)
                }
        
        
        func fillPasswordField(password: String) {
            
            //        let passwordTextField = app.secureTextFields.containing(NSPredicate(format: "placeholderValue == %@", "Password")).element
            
            checkElementExists(elements: [passwordTextField], timeout: 1)
            passwordTextField.tap()
            passwordTextField.typeText(password)
        }
       
    
    
    
    
    func retryLogin (confirm: Bool, maxRetries: Int = 3) {
        let loginAlert = app.alerts["Error"]
        let retryButton = app.buttons["Retry"]
        let cancelButton = app.buttons["Cancel"]
        
        var attempts = 0
        
        //loop
        while attempts < maxRetries {
            
            // Check if the error alert is present
            if loginAlert.waitForExistence(timeout: 5) {
                // Wait for the retry button to appear
                if retryButton.waitForExistence(timeout: 1) {
                    // Tap the appropriate button based on the confirm parameter
                    if confirm {
                        retryButton.tap()
                    } else {
                        cancelButton.tap()
                    }
                } else {
                    XCTFail("Retry button not found in error alert.")
                }
            } else {
                return
            }
            // Increment attempts
            attempts += 1
            
            // Check if maximum retries reached
            if attempts >= maxRetries {
                XCTFail("Impossible to login after \(maxRetries) attempts.")
            }
            
        }
    }
    
    
    func errorLoginAlertIs() -> Bool {
        let loginAlert = app.alerts["Error"]
        return loginAlert.exists
    }
    
    

    
    
    }
    

  
   
        
        
        
        //dont use this func
//        func tapReturnKey() {
//            let returnKey = app.buttons["Return"]
//            if returnKey.exists {
//                returnKey.tap()
//            } else {
//                XCTFail("Return key does not exist")
//            }
//        }
        
        
        
       
        
        
        
//        func checkElementsAreHittable(elements: [XCUIElement], after timeout: TimeInterval) -> (allHittable: Bool, nonHittableButtons: [XCUIElement]) {
//            var nonHittableButtons: [XCUIElement] = []
//            for element in elements {
//                if !element.isHittable {
//                    nonHittableButtons.append(element)
//                }
//            }
//            return (nonHittableButtons.isEmpty, nonHittableButtons)
//        }
//        
//        
//        
//        func checkAllButtonsAreHittable(app: XCUIApplication, timeout: TimeInterval = 5) -> (allHittable: Bool, nonHittableButtons: [XCUIElement]) {
//            let buttons = app.buttons.allElementsBoundByIndex
//            return checkElementsAreHittable(elements: buttons, after: timeout)
//        }
//        
//}
