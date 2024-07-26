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
    var completeAll: XCUIElement!
    var allCheckboxes: XCUIElementQuery!
    var cancellAll: XCUIElement!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
        // Initialize UI elements
        passwordTextField = app.secureTextFields.containing(NSPredicate(format: "placeholderValue == %@", "Password")).firstMatch
        emailTextField = app.textFields.containing(NSPredicate(format: "placeholderValue == %@", "Email")).firstMatch
        logoutButton = app.buttons["Logout"].firstMatch
        loginButton = app.buttons["login-button"].firstMatch
        checklistpoint = app.staticTexts["Buy milk"].firstMatch
        alerts = app.alerts.firstMatch
        completeAll = app.buttons["Complete All"].firstMatch
        allCheckboxes = app.tables.cells.descendants(matching: .image).matching(identifier: "cell_image_view")
        cancellAll = app.buttons["Cancel All"].firstMatch
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
        tapReturnKey()
        //enter password
        fillPasswordField(password: password)
        tapReturnKey()
        //verification that login button exists + tap
        checkElementExists(elements: [loginButton], timeout: 1)
        app.buttons["login-button"].firstMatch.tap()
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
            handleLogout(confirm: confirm)
        }
    }
    
    //Handle the logout confirmation alert
    private func handleLogout(confirm: Bool) {
        let logoutButton = alerts.buttons["Logout"].firstMatch
        let cancelButton = alerts.buttons["Cancel"].firstMatch
        
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
        let tasksScreenElement = app.buttons["Logout"].firstMatch
        return tasksScreenElement.exists
    }
    
    func tapReturnKey() {
        let systemKeyboard = app.keyboards.firstMatch
        let returnKey = systemKeyboard.buttons["Return"].firstMatch
        
        //Find and check that keyboard is shown
        XCTAssertTrue(systemKeyboard.exists, "System keyboard should be visible")
        //Check that the Return button exists and is hittable
        XCTAssertTrue(returnKey.exists && returnKey.isHittable, "Return key should exist and be hittable")
        //tap on Return button and check that Keyboad closes
        returnKey.tap()
        XCTAssertFalse(systemKeyboard.exists, "System keyboard should be closed after tapping the Return key")
    }
    
    func completeAllCheckboxes() {
        //Check "Complete All" button existance, tap it
        checkElementExists(elements: [completeAll], timeout: 1)
        completeAll.tap()
        //Check "Cancell All" button existance, tap it
        checkElementExists(elements: [cancellAll], timeout: 1)
    }
    
    func fetchTaskNames(from app: XCUIApplication) -> [String] {
        //Create an empty array of strings that will hold the names of the tasks
        var taskNames: [String] = []
        let taskCells = app.tables.cells
        
        for i in 0..<taskCells.count {
            let taskCell = taskCells.element(boundBy: i)
            let taskName = taskCell.staticTexts.element(boundBy: 0).label
            taskNames.append(taskName)
        }
        return taskNames
    }
}
