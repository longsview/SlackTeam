//
//  UserListViewModelTests.swift
//  SlackTeamTests
//
//  Created by Nicholas Long on 2/9/18.
//  Copyright © 2018 Nicholas Long. All rights reserved.
//

import XCTest
@testable import SlackTeam

class WebServiceMock: WebService {
    override func getUsers(completion: @escaping ([User], Error?) -> Void) {
        completion([User](), nil)
    }
}

class UserListViewModelMock: UserListViewModel {
    
    var webServiceMock = WebServiceMock()
    override var webService: WebService {
        return webServiceMock
    }
}

class UserListViewModelTests: XCTestCase, UserListViewDelegate {
    
    var userListViewModel: UserListViewModelMock?

    var modelLoaded = false
    func loaded() {
        modelLoaded = true
    }
    
    override func setUp() {
        super.setUp()
        
        userListViewModel = UserListViewModelMock(view: self)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testModelLoadsOnInit() {
        XCTAssertTrue(modelLoaded)
    }
    
    func testPredicateUpdatedOnFilter() {
        XCTAssertNil(userListViewModel?.fetchedResultsController.fetchRequest.predicate)
        userListViewModel?.filterString = "Test"
        XCTAssertNotNil(userListViewModel?.fetchedResultsController.fetchRequest.predicate)
    }

    func testPredicateUpdatedOnFilterReset() {
        XCTAssertNil(userListViewModel?.fetchedResultsController.fetchRequest.predicate)
        userListViewModel?.filterString = "Test"
        XCTAssertNotNil(userListViewModel?.fetchedResultsController.fetchRequest.predicate)
        userListViewModel?.filterString = ""
        XCTAssertNil(userListViewModel?.fetchedResultsController.fetchRequest.predicate)
        userListViewModel?.filterString = nil
        XCTAssertNil(userListViewModel?.fetchedResultsController.fetchRequest.predicate)
    }

    func testSortPredicate() {
        XCTAssertEqual(userListViewModel?.fetchedResultsController.fetchRequest.sortDescriptors?[0].key, "name")
    }

    func testUpdateSortPredicate() {
        XCTAssertEqual(userListViewModel?.fetchedResultsController.fetchRequest.sortDescriptors?[0].key, "name")
        userListViewModel?.sortString = "realName"
        XCTAssertEqual(userListViewModel?.fetchedResultsController.fetchRequest.sortDescriptors?[0].key, "realName")
    }
}
