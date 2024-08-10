//
//  NYCSATTests.swift
//  NYCSATTests
//
//  Created by sade on 8/10/24.
//

import XCTest
@testable import NYCSAT

final class NYCSATTests: XCTestCase {

  var viewModel: ViewModel?

    //resets state before each test
    override func setUp() {
      super.setUp()
      viewModel = ViewModel()

    }
    //clean up after each test to release viewmodel reference
    override func tearDown() {
      viewModel = nil
      super.tearDown()
    }

    func testLoadData() {
      let expectation = XCTestExpectation(description: "Download NYC School data")

      viewModel?.loadData()
      viewModel?.loadScoreData()

      DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
        XCTAssertFalse(((self.viewModel?.items.isEmpty) != nil), "School data should be empty")
        XCTAssertFalse(((self.viewModel?.scoreItems.isEmpty) != nil), "SAT score data should not be empty")
        expectation.fulfill()
      }

      wait(for: [expectation], timeout: 5.0)
    }

  }
