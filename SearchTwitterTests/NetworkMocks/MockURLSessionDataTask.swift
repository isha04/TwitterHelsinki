//
//  MockURLSessionDataTask.swift
//  SearchTwitterTests
//
//  Created by Isha Dua on 12/10/21.
//

import Foundation
@testable import SearchTwitter

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private (set) var resumeWasCalled = false

    func resume() {
        resumeWasCalled = true
    }
}
