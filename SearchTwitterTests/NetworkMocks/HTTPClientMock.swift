//
//  HTTPClientMock.swift
//  SearchTwitterTests
//
//  Created by Isha Dua on 13/10/21.
//

import Foundation
@testable import SearchTwitter

class HTTPManagerMock <T: URLSessionProtocol>: HTTPManagerProtocol {
    var session: URLSessionProtocol
    
    var imageLoadDataTask: URLSessionDataTaskProtocol?
    
    required init(session: URLSessionProtocol) {
        self.session = session
    }
    
    func get(url: URL, requestFields: [URLRequstFieldValue]?, completionBlock: @escaping (Result<Data, Error>) -> Void) {
        if let dta = "This Succeeded".data(using: .utf8) {
            completionBlock(.success(dta))
        }
    }
}
