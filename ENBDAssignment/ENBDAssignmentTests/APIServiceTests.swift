//
//  APIServiceTests.swift
//  ENBDAssignmentTests
//
//  Created by Sharon on 23/03/2020.
//  Copyright © 2020 Sharon. All rights reserved.
//

import XCTest
@testable import ENBDAssignment

class APIServiceTests: XCTestCase {
    
    var sut: APIService?
    
    override func setUp() {
        super.setUp()
        sut = APIService()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    
    func test_searchResults_Response() {
        
        let sut = self.sut!
        let expect = XCTestExpectation(description: "Search Results Expectation")
        sut.search(keyWord: "apple", loadMore: false) { (photos, error) in
            
            expect.fulfill()
            if let photos = photos {
                for photo in photos {
                    XCTAssertNotNil(photo.id)
                    XCTAssertNotNil(photo.previewURL)
                    XCTAssertNotNil(photo.largeImageURL)
                }
            }
           
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    func test_search_item_per_size_exceeds_20() {
        
        let sut = self.sut!
        let expect = XCTestExpectation(description: "Search results items per page expectation")
        sut.search(keyWord: "apple", loadMore: false) { (photos, error) in
            expect.fulfill()
            if let numberOfItems = photos?.count {
                XCTAssertFalse(numberOfItems > 20)
            }
           
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    
}
