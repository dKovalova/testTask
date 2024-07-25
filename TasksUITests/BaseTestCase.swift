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
    //create separeted class for variable
    let app = XCUIApplication()
    lazy var testStrings = TestsStrings()
    var emailTextField: XCUIElement!
    var passwordTextField: XCUIElement!
    var logoutButton: XCUIElement!
    var loginButton: XCUIElement!
    var checklistpoint: XCUIElement!
    var alerts: XCUIElement!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
        // Initialize UI elements
        passwordTextField = app.secureTextFields.containing(NSPredicate(format: "placeholderValue == %@", "Password")).firstMatch
        emailTextField = app.textFields.containing(NSPredicate(format: "placeholderValue == %@", "Email")).firstMatch
        logoutButton = app.buttons["Logout"]
        loginButton = app.buttons["login-button"]
        checklistpoint = app.staticTexts["Buy milk"]
        alerts = app.alerts.firstMatch
    }
    
    override func tearDownWithError() throws {
        // logout if user is logged in
        if self.isUserLoggedIn() {
            self.logout(confirm: true)
        }
        // Call super to ensure any additional teardown logic in XCTestCase is executed
        try super.tearDownWithError()
    }
    
    func checkElementExists(elements: [XCUIElement], timeout: TimeInterval) {
        for element in elements {
            let exists = element.waitForExistence(timeout: timeout)
            XCTAssertTrue(exists, "Element \(element) does not exist.")
        }
    }
    
    func fillEmailField(email: String) {
        checkElementExists(elements: [emailTextField], timeout: 1)
        emailTextField.tap()
        emailTextField.typeText(email)
    }
    
    func fillPasswordField(password: String) {
        checkElementExists(elements: [passwordTextField], timeout: 1)
        passwordTextField.tap()
        passwordTextField.typeText(password)
    }
    
    func isButtonHittable(button: XCUIElement) -> Bool {
        XCTAssertTrue(button.exists, "\(button) button does not exist")
        return button.isHittable
    }
    
    func logIn(email: String, password: String) {
        // enter email
        fillEmailField(email: email)
        app.keyboards.buttons["Return"].tap()
        //enter password
        fillPasswordField(password: password)
        app.keyboards.buttons["Return"].tap()
        //verification that login button exists + tap
        checkElementExists(elements: [loginButton], timeout: 1)
        app.buttons["login-button"].tap()
    }
    
    func clearTextInField(_ element: XCUIElement) {
        XCTAssertTrue(element.exists, "Text field does not exist")
        element.tap()
        guard let stringValue = element.value as? String else {
            XCTFail("Element does not contain a string value")
            return
        }
        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
        element.typeText(deleteString)
    }
    
    // Function to handle logout if logged in
    func logout(confirm: Bool) {
        if isUserLoggedIn() {
            logoutButton.tap()
            handleLogoutAlert(confirm: confirm)
        }
    }
    
    //Handle the logout confirmation alert
    private func handleLogoutAlert(confirm: Bool) {
        let logoutButton = alerts.buttons["Logout"]
        let cancelButton = alerts.buttons["Cancel"]
        
        //for debug
        print("Alert exists: \(alerts.exists)")
        if logoutButton.waitForExistence(timeout: 2) {
            if confirm {
                print("Tapping Logout button")
                logoutButton.tap()
            } else {
                print("Tapping Cancel button")
                cancelButton.tap()
            }
        } else {
            XCTFail("Logout confirmation alert did not appear.")
        }
    }
    
    func closeAppAlerts(with option: String? = nil) {
        let alerts = app.alerts
        var retryCount = 0
        // Retry up to 2 times if alerts exist
        while retryCount < 2 {
            if alerts.firstMatch.waitForExistence(timeout: 5) {
                while alerts.count > 0 {
                    if let option = option {
                        let buttonToTap = alerts.buttons[option].firstMatch
                        XCTAssert(buttonToTap.waitForExistence(timeout: 2), "\(option) is not available in alert")
                        buttonToTap.tap()
                    } else {
                        if alerts.buttons.count > 1 {
                            alerts.buttons.element(boundBy: 1).tap()
                        } else {
                            alerts.buttons.firstMatch.tap()
                        }
                    }
                }
                retryCount += 1
            } else {
                // No alert exists, break the loop
                break
            }
        }
    }
    
    //for tearnDown in tasks class
    func isUserLoggedIn() -> Bool {
        let tasksScreenElement = app.buttons["Logout"]
        return tasksScreenElement.exists
    }
    
}

//    func errorLoginAlertIs(timeout: TimeInterval) -> Bool {
//        let loginAlert = app.alerts["Error"]
//        return loginAlert.waitForExistence(timeout: timeout)
//    }
//
//
//    func retryLogin (confirm: Bool, maxRetries: Int = 2) {
//        let loginAlert = app.alerts["Error"]
//        let retryButton = app.buttons["Retry"]
//        let cancelButton = app.buttons["Cancel"]
//
//        var attempts = 0
//
//        //loop
//        while attempts < maxRetries {
//
//            // Check if the error alert is present
//            if loginAlert.waitForExistence(timeout: 5) {
//                // Wait for the retry button to appear
//                if retryButton.waitForExistence(timeout: 1) {
//                    // Tap the appropriate button based on the confirm parameter
//                    if confirm {
//                        retryButton.tap()
//                    } else {
//                        cancelButton.tap()
//                    }
//                } else {
//                    XCTFail("Retry button not found in error alert.")
//                }
//            } else {
//                return
//            }
//            // Increment attempts
//            attempts += 1
//
//            // Check if maximum retries reached
//            //change maxRetries  = 3
//            if attempts >= maxRetries {
//                XCTFail("Impossible to login after \(maxRetries) attempts.")
//            }
//
//        }
//    }
//
//    func incorrectLoginValuesAlertIs(expectedMessage: String) -> Bool {
//        // Create a predicate to find the alert with the specific label 'Error'
//        let errorAlertPredicate = NSPredicate(format: "label == %@", "Error")
//        let errorAlert = app.alerts.element(matching: errorAlertPredicate)
//
//        // Verify if the alert exists
//        if errorAlert.exists {
//            // Create a predicate to find the static text within the alert
//            let messageTextPredicate = NSPredicate(format: "label == %@", expectedMessage)
//            let messageTextElement = errorAlert.staticTexts.element(matching: messageTextPredicate)
//
//            // Return true if the specific message is found
//            return messageTextElement.exists
//        }
//
        // Return false if the alert itself does not exist
//        return false

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
