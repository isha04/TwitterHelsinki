//
//  MockURLSession.swift
//  SearchTwitterTests
//
//  Created by Isha Dua on 12/10/21.
//

import Foundation
@testable import SearchTwitter

class MockURLSession: URLSessionProtocol {
    
    private (set) var lastURL: URL?
    var nextDataTask = MockURLSessionDataTask()
    var nextData: Data?
    var nextError: Error?
    
    func dataTask(with url: URL, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        lastURL = url
        completionHandler(nextData, nil, nextError)
        return nextDataTask
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        lastURL = request.url
        completionHandler(nextData, nil, nextError)
        return nextDataTask
    }
}
