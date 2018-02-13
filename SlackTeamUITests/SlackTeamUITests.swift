//
//  SlackTeamUITests.swift
//  SlackTeamUITests
//
//  Created by Nicholas Long on 2/9/18.
//  Copyright © 2018 Nicholas Long. All rights reserved.
//

import XCTest

class SlackTeamUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()

        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInitialListLoads() {

        let app = XCUIApplication()
        XCTAssertTrue(app.tables.cells.staticTexts["CEO"].isHittable)
    }
    
    func testUserViewLoads() {
        
        let app = XCUIApplication()
        XCTAssertTrue(app.tables.cells.staticTexts["CEO"].isHittable)
        
        app.tables.cells.staticTexts["CEO"].tap()
        XCTAssertTrue(app.navigationBars.staticTexts["Natalie George"].isHittable)
    }

    func testPhoneButtonVisible() {

        let app = XCUIApplication()
        XCTAssertTrue(app.tables.cells.staticTexts["CEO"].isHittable)
        
        app.tables.cells.staticTexts["CEO"].tap()
        XCTAssertTrue(app.navigationBars.staticTexts["Natalie George"].isHittable)
        XCTAssertTrue(app.buttons["phone"].isHittable)
    }

    func testFilter() {
        
        let app = XCUIApplication()
        app.tables.element.swipeDown()
        let searchSearchField = app.searchFields["Search"]
        searchSearchField.tap()
        searchSearchField.typeText("Tes")
        XCTAssertFalse(app.tables.cells.staticTexts["CEO"].exists)

        app.buttons["Cancel"].tap()
        XCTAssertTrue(app.tables.cells.staticTexts["CEO"].isHittable)
    }
}
