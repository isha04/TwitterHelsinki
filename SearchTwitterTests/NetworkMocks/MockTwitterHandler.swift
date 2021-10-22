//
//  MockTwitterHandler.swift
//  SearchTwitterTests
//
//  Created by Isha Dua on 14/10/21.
//

import Foundation
@testable import SearchTwitter

class MockTwitterHandler: TwitterAPIHandler {
    
    override func getData(withAPIEndpoint apiEndpoint: String, queryParams: [String : String]?, requestCompletionHandler: @escaping (Result<Data, Error>) -> Void) {
        let session = MockURLSession()
        let httpManager = HTTPManager(session: session)
        let data = loadJsonFile(name: "tweet")
        session.nextData = data
        let url = URL(string: "http://www.google.com")!
        httpManager.get(url: url, requestFields: nil) { result in
            requestCompletionHandler(result)
        }
    }
}
