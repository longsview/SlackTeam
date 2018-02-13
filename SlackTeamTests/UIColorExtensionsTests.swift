//
//  UIColorExtensionsTests.swift
//  SlackTeamTests
//
//  Created by Nicholas Long on 2/12/18.
//  Copyright © 2018 Nicholas Long. All rights reserved.
//

import XCTest
@testable import SlackTeam

class UIColorExtensionsTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testWhite() {
        let white = UIColor(hexString: "#ffffff")
        let whiteColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        XCTAssertTrue(white.isEqual(whiteColor))
    }

    func testBlack() {
        let black = UIColor(hexString: "#000000")
        let blackColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        XCTAssertTrue(black.isEqual(blackColor))
    }

    func testInvalidColor() {
        let invalid = UIColor(hexString: "#gggggg")
        let blackColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        XCTAssertTrue(invalid.isEqual(blackColor))
    }

    func testLongColorString() {
        let color = UIColor(hexString: "#ffffff000")
        let whiteColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        XCTAssertTrue(color.isEqual(whiteColor))
    }

    func testNoHashtag() {
        let color = UIColor(hexString: "ffffff")
        let whiteColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        XCTAssertTrue(color.isEqual(whiteColor))
    }
}

