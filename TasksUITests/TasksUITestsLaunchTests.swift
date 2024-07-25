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
}
