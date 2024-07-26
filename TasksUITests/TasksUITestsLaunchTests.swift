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
        
        // Login if user is logged out
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
        //checked determines whether the checkbox should be "Selected" (if true) or "Not selected" (if false) (fixed).
        // expectedValue is dynamically set based on this logic
        let expectedValue = checked ? "Selected" : "Not selected"
        XCTAssertEqual(checkbox.value as? String, expectedValue, "Checkbox state should be \(expectedValue) after tapping on it")
    }
    
    func testCompleteAll() {
        completeAllCheckboxes()
        //Verify that all checkboxes are selected
        for i in 0..<allCheckboxes.count {
            let checkbox = allCheckboxes.element(boundBy: i)
            assertCheckbox(checkbox, becameChecked: true)
        }
    }
    
    func testCancellAll() {
        completeAllCheckboxes()
        cancellAll.tap()
        //Verify that checkboxes are deselected
        for i in 0..<allCheckboxes.count {
            let checkbox = allCheckboxes.element(boundBy: i)
            assertCheckbox(checkbox, becameChecked: false)
        }
        //Check that "Cancel All" button is replaced by "Complete All"
        checkElementExists(elements: [completeAll], timeout: 1)
    }
    
    //add verification that status of list items (selected/ not selected) doesn't change
    func testSortByName() {
        let sortButton = app.buttons["sort-tasks-bar-button-item"].firstMatch
        // Fetch initial list of task names
        let initialTaskNames = fetchTaskNames(from: app)
        
        sortButton.tap()
        // Fetch the task names after sorting A-Z
        let sortAZ = fetchTaskNames(from: app)
        // Verify the tasks are sorted A-Z
        XCTAssertEqual(sortAZ, initialTaskNames.sorted(), "Tasks are not sorted A-Z")
        // Tap the sort button again to sort Z-A
        sortButton.tap()
        // Fetch the task names after sorting Z-A
        let sortZA = fetchTaskNames(from: app)
        // Verify the tasks are sorted Z-A
        XCTAssertEqual(sortZA, initialTaskNames.sorted(by: >), "Tasks are not sorted Z-A")
    }
}
