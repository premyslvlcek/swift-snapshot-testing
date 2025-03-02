//
//  Async+Delay.swift
//  swift-snapshot-testing
//
//  Created by Premysl Vlcek on 01.03.2025.
//

import Foundation
import XCTest

extension Async {
  /// Delays Async `run` block
  /// - Parameter timeInterval: Optional duration for Async to wait before running `run`
  /// - Returns: Delayed `Async` unless no duration was provided then returns original `Async`
  func delay(by timeInterval: TimeInterval?) -> Async<Value> {
    guard let timeInterval else {
      return self
    }
    
    return Async<Value> { callback in
      run { value in
        
        let expectation = XCTestExpectation(description: "delay")
        DispatchQueue.main.asyncAfter(deadline: .now() + timeInterval) {
          expectation.fulfill()
        }
        _ = XCTWaiter.wait(for: [expectation], timeout: timeInterval + 1)
        
        callback(value)
      }
    }
  }
}
