//
//  ImageLoader.swift
//  SearchTwitter
//
//  Created by Isha Dua on 07/10/21.
//

import UIKit

class ImageLoader {
    private var loadedImages = [URL: UIImage]()
    private var runningRequests = [UUID: URLSessionDataTaskProtocol]()
    
    static let sharedLoader = ImageLoader()
    let httpManager = HTTPManager(session: URLSession(configuration: .default))
    
    /**
     Fetches the required image from cache. If image is not available in cache, then, the image is fetched from the network. If the image is not found, due to some reason, then a default thumbnail image is returned.
     */

    func loadImage(_ url: URL, _ completion: @escaping (Result<UIImage, Error>) -> Void) -> UUID? {
        if let image = loadedImages[url] {
            completion(.success(image))
            return nil
        }

        let uuid = UUID()
        
            httpManager.getImage(url: url) { [weak self] imageResult in
                defer { self?.runningRequests.removeValue(forKey: uuid) }
            
            switch imageResult {
            case .success(let data):
                if let image = UIImage(data: data) {
                    self?.loadedImages[url] = image
                    completion(.success(image))
                } else {
                    let symbolConfig = UIImage.SymbolConfiguration(weight: .light)
                    let defaultImage = UIImage(systemName: "person.circle.fill", withConfiguration: symbolConfig)
                    completion(.success(defaultImage!))
                }
            case .failure(let error):
                completion(.failure(error))
            }
            
            self?.runningRequests[uuid] = self?.httpManager.imageLoadDataTask
      
        }
        
      return uuid
    }
    
    func cancelImageLoadRequest(_ uuid: UUID) {
        if let task = runningRequests[uuid] as? URLSessionDataTask {
            task.cancel()
            runningRequests.removeValue(forKey: uuid)
        }
    }
}
