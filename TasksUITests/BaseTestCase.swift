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
    
    override func setUpWithError() throws {
        // fix "app.launch()" usage in each func
        continueAfterFailure = false
        app.launch()
    }
    
    
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    func fillEmailField(email: String) {

        let emailTextField = app.textFields["Email"]
        
        checkElementExists(elements: [emailTextField], timeout: 1)
        emailTextField.tap()
        emailTextField.typeText(email)
    }
    
    
    func fillPasswordField(password: String) {

        //        let passwordTextField = app.secureTextFields.containing(NSPredicate(format: "placeholderValue == %@", "Password")).element
        
        let passwordTextField = app.secureTextFields["Password"]
        checkElementExists(elements: [passwordTextField], timeout: 1)
        
        passwordTextField.tap()
        passwordTextField.typeText(password)
    }
    
    func logout(confirm: Bool) {

        let logout = app.buttons["Logout"]
        checkElementExists(elements: [logout], timeout: 5)
        logout.tap()
        confirmAndCancelLogout(confirm: confirm)
        
    }
    
    
    func confirmAndCancelLogout(confirm: Bool) {

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
            return
        }
    }
    
    
    func checkElementExists(elements: [XCUIElement], timeout: TimeInterval) {
        for element in elements {
            let exists = element.waitForExistence(timeout: timeout)
            XCTAssertTrue(exists, "Element \(element) does not exist.")
        }
        
        
        
        func tapReturnKey() {
            let returnKey = app.buttons["Return"]
            if returnKey.exists {
                returnKey.tap()
            } else {
                XCTFail("Return key does not exist")
            }
        }
        
        
        
        func checkElementsAreHittable( elements: [XCUIElement], after  timeout: TimeInterval) -> Bool {
            let predicate = NSPredicate { obj, context -> Bool in
                let elements = obj as! [XCUIElement]
                for element in elements {
                    if false == element.isHittable {
                        return false
                    }
                }
                return true
            }
            let expectation = XCTNSPredicateExpectation(predicate: predicate, object: elements)
                let result = XCTWaiter().wait(for: [expectation], timeout: timeout)
                return result == .completed
        }
        
        func checkAllButtonsAreHittable(app: XCUIApplication, timeout: TimeInterval = 5) -> Bool {
               let buttons = app.buttons.allElementsBoundByIndex
               return checkElementsAreHittable(elements: buttons, after: timeout)
           }
           
    
        
        
    }
}
