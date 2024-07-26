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
        
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        // Initialize login screen elements
        if !self.isUserLoggedIn() {
            self.logIn(email: testStrings.validEmail, password: testStrings.validPassword)
        }
        if alerts.waitForExistence(timeout: 5) {
                closeAppAlerts(with: "Retry")
        }
       //Check that User is Logged in
        self.checkElementExists(elements: [checklistpoint], timeout: 3)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func testConfirmLogout() {
        self.logout(confirm: true)
        // verification that Login screen appears
        self.checkElementExists(elements: [emailTextField], timeout: 2)
        // Restart the app
        app.terminate()
        app.launch()
        // Verify that the Login screen appears again after restarting the app
        // Verify that the Login screen appears again after restarting the app
        XCTAssert(emailTextField.exists, "Email text field is not found after app restoration")
    }

    func testCancelLogout() {
        logout(confirm: false)
        //add verification that Tasks screen opened
        checkElementExists(elements: [checklistpoint], timeout: 3)
    }
        
    func testCheckboxesVerification() {
        // Assuming the checkboxes are in a table
        let allCheckboxes = app.tables.cells.descendants(matching: .image).matching(identifier: "cell_image_view")
        
        //Verify that no checkboxes are marked initially
        for i in 0..<allCheckboxes.count {
            let checkbox = allCheckboxes.element(boundBy: i)
            assertCheckbox(checkbox, becameChecked: false)
        }
        //Tap  on the each checkbox and check that cell is marked
        for i in 0..<allCheckboxes.count {
            let checkbox = allCheckboxes.element(boundBy: i)
            // Tap on the checkbox to check it
            checkbox.tap()
            // Verify that the checkbox is marked
            assertCheckbox(checkbox, becameChecked: true)
            // Verify that only this checkbox is marked, and others are not
            for j in 0..<allCheckboxes.count {
                let otherCheckboxes = allCheckboxes.element(boundBy: j)
                let shouldBeChecked = (i == j)
                assertCheckbox(otherCheckboxes, becameChecked: shouldBeChecked)
            }
            // Tap on the checkbox to uncheck it
            checkbox.tap()
            // Verify that the checkbox is not marked
            assertCheckbox(checkbox, becameChecked: false)
            //Verify that no checkboxes are marked
            for j in 0..<allCheckboxes.count {
                let otherCheckboxes = allCheckboxes.element(boundBy: j)
                assertCheckbox(otherCheckboxes, becameChecked: false)
            }
        }
    }
        
    private func assertCheckbox(_ checkbox: XCUIElement, becameChecked checked: Bool) {
        let expectedValue = checked ? "Selected" : "Not selected"
        XCTAssertEqual(checkbox.value as? String, expectedValue, "Checkbox state should be \(expectedValue) after tapping on it")
    }
}
