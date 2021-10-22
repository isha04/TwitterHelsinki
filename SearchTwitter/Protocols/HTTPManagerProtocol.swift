//
//  HTTPManagerProtocol.swift
//  SearchTwitter
//
//  Created by Isha Dua on 30/09/21.
//

import Foundation

typealias URLRequstFieldValue = (httpFieldName: String, fieldValue: String)

protocol HTTPManagerProtocol {
    var session: URLSessionProtocol { get }
    var imageLoadDataTask: URLSessionDataTaskProtocol? { get }
    init(session: URLSessionProtocol)
    
    func get(url: URL, requestFields: [URLRequstFieldValue]?, completionBlock: @escaping (Result<Data, Error>) -> Void)
}
