//
//  HTTPManager.swift
//  SearchTwitter
//
//  Created by Isha Dua on 30/09/21.
//

import Foundation

class HTTPManager: HTTPManagerProtocol {
    
    var session: URLSessionProtocol
    var imageLoadDataTask: URLSessionDataTaskProtocol?
    var searchDataLoadTask: URLSessionDataTaskProtocol?
    
    required init(session: URLSessionProtocol) {
        self.session = session
    }
    
    func get(url: URL, requestFields: [URLRequstFieldValue]?, completionBlock: @escaping (Result<Data, Error>) -> Void){
        var request = URLRequest(url: url)
        
        if let fieldsDict = requestFields {
            for pair in fieldsDict {
                request.addValue(pair.fieldValue, forHTTPHeaderField: pair.httpFieldName)
            }
        }        
        
        let task = session.dataTask(with: request) { data, response, error in
            
            if let nsError = error as NSError? {
                switch nsError.code {
                case NSURLErrorTimedOut, NSURLErrorCannotConnectToHost,
                     NSURLErrorNetworkConnectionLost, NSURLErrorNotConnectedToInternet:
                    completionBlock(.failure(HTTPError.noInternet))
                case NSURLErrorBadURL, NSURLErrorUnsupportedURL:
                    completionBlock(.failure(HTTPError.invalidURL))
                default:
                    completionBlock(.failure(nsError))
                }
            }
            
            guard let responseData = data else {
                completionBlock(.failure(HTTPError.invalidResponse(data, response)))
                return
            }
            
            do{
                //here dataResponse received from a network request
                let _ = try JSONSerialization.jsonObject(with:
                    responseData, options: [])
                completionBlock(.success(responseData))
            } catch let parsingError {
                completionBlock(.failure(parsingError))
            }
        }
        
        searchDataLoadTask = task
        task.resume()
    }
    
    func getImage(url: URL, completionBlock: @escaping (Result<Data, Error>) -> Void){
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { data, response, error in
            if let nsError = error as NSError? {
                switch nsError.code {
                case NSURLErrorTimedOut, NSURLErrorCannotConnectToHost,
                     NSURLErrorNetworkConnectionLost, NSURLErrorNotConnectedToInternet:
                    completionBlock(.failure(HTTPError.noInternet))
                case NSURLErrorBadURL, NSURLErrorUnsupportedURL:
                    completionBlock(.failure(HTTPError.invalidURL))
                default:
                    completionBlock(.failure(nsError))
                }
            }
            
            guard let responseData = data
            else {
                completionBlock(.failure(HTTPError.invalidResponse(data, response)))
                return
            }
            
            completionBlock(.success(responseData))
        }
        
        imageLoadDataTask = task
        task.resume()
    }
}
