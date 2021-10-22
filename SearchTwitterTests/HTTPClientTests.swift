//
//  HTTPClientTests.swift
//  SearchTwitterTests
//
//  Created by Isha Dua on 30/09/21.
//

import XCTest
@testable import SearchTwitter

class HTTPClientTests: XCTestCase {
    var sut: HTTPManager!
    var session: MockURLSession!
    let url = URL(string: "http://www.google.com")!
    
    override func setUp() {
        super.setUp()
        session = MockURLSession()
        sut = HTTPManager(session: session)
    }

    func test_GET_RequestsTheURL() {
        sut.get(url: url, requestFields: nil) { _ in }
        XCTAssertEqual(session.lastURL, url)
    }
    
    func test_GET_StartsTheRequest() {
        let dataTask = MockURLSessionDataTask()
        session.nextDataTask = dataTask
        sut.get(url: url, requestFields: nil) { _ in }
        XCTAssert(dataTask.resumeWasCalled)
    }

    func test_GET_WithResponseData_ReturnsTheData() {
        let expectedData = "{}".data(using: .utf8)
        session.nextData = expectedData

        var actualData: Data?
        sut.get(url: url, requestFields: nil) { result  in
            switch result {
            case .success(let data):
                actualData = data
            case .failure(_):
                print("An error occured")
            }
         }

         XCTAssertEqual(actualData, expectedData)
     }

    func test_GET_WithANetworkError_ReturnsANetworkError() {
        session.nextError = NSError(domain: "error", code: 0, userInfo: nil)

        var error: Error?
        sut.get(url: url, requestFields: nil) { result -> Void in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let receivedError):
                error = receivedError
            }
        }

        XCTAssertNotNil(error)
    }
    
    func test_GET_SuccessfulData_Parsing() {
        let data = loadJsonFile(name: "tweet")
        session.nextData = data
        sut.get(url: url, requestFields: nil) { result in
            switch result {
            case .success(let receivedData):
                let content = try! JSONDecoder().decode(TwitterSearchData.self, from: receivedData)
                let tweetData = content.data[0]
                XCTAssertEqual(tweetData.text, "RT @BeatrizBarreir3: Helsinki - Cartelera - Teatros Luchana https://t.co/vxrbmJKBwr")
            case .failure(let error):
                print(error)
            
            }
        }
        
    }
}

func loadJsonFile(name: String) -> Data? {
    do {
        if let filePath = Bundle.main.path(forResource: name, ofType: "json") {
            let fileUrl = URL(fileURLWithPath: filePath)
            let data = try Data(contentsOf: fileUrl)
            return data
        }
    } catch {
        print("error: \(error)")
    }

    return nil
}
