//
//  TwitterAPIHandler.swift
//  SearchTwitter
//
//  Created by Isha Dua on 01/10/21.
//

import Foundation

class TwitterAPIHandler {
    
    private var runningRequests = [String: URLSessionDataTaskProtocol]()
    
    func getData(withAPIEndpoint apiEndpoint: String, queryParams: [String:String]?, requestCompletionHandler: @escaping (Result<Data, Error>) -> Void) {
        
        let httpManager = HTTPManager(session: URLSession(configuration: .default))
        
        var apiURLCompnent = URLComponents()
        apiURLCompnent.scheme = "https"
        if let key = Bundle.main.infoDictionary?["API_ENDPOINT"] as? String {
            apiURLCompnent.host = key
        }
        apiURLCompnent.path = "/" + apiEndpoint
        
        var items = [URLQueryItem]()
        
        if queryParams != nil {
            for (key,value) in queryParams! {
                items.append(URLQueryItem(name: key, value: value))
            }
            apiURLCompnent.queryItems = items
        }
        
        guard let url = apiURLCompnent.url else {
            requestCompletionHandler(.failure(HTTPError.invalidURL))
            return
        }
        
        let bearerToken =  (httpFieldName: "Authorization", fieldValue:  "Bearer \(Bundle.main.infoDictionary?["API_KEY"] ?? "")")
        
        httpManager.get(url: url, requestFields: [bearerToken] , completionBlock: { [weak self] result in
            if let token = queryParams?["next_token"] {
                self?.runningRequests[token] = httpManager.searchDataLoadTask
                
            }
                        
            requestCompletionHandler(result)
        })
    }
    
    func removeDataLoadRequest(_ key: String) {
        if let task = runningRequests[key] as? URLSessionDataTask {
            task.cancel()
            runningRequests.removeValue(forKey: key)
        }
    }
}
